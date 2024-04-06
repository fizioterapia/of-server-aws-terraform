data "template_file" "ec2_setup_script" {
  template = <<-EOT
#!/bin/bash
sudo apt update
sudo apt install curl nginx -y

# Configure SSH access for admin user
mkdir /home/admin/.ssh
chmod 700 /home/admin/.ssh

curl https://github.com/${var.github_username}.keys | tee -a /home/admin/.ssh/authorized_keys
chmod 600 /home/admin/.ssh/authorized_keys
chown -R admin:admin /home/admin

# Configure redirect for GitHub profile
echo -e "<html>\n<head>\n<meta http-equiv=\"refresh\" content=\"0; URL='https://github.com/${var.github_username}'\" />\n</head>\n</html>" | sudo tee /var/www/html/index.html > /dev/null

# Open Fortress Installation
# Install SDK and TF2
dpkg --add-architecture i386 && apt-get update && apt-get install -y \
  lib32gcc-s1 libstdc++6 libstdc++6:i386 libncurses5:i386 libtinfo5:i386 \
  libcurl4-gnutls-dev:i386 screen aria2 jq

mkdir ~/Steam && cd ~/Steam
curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

echo -e "@ShutdownOnFailedCommand 1\n@NoPromptForPassword 1\nlogin anonymous\nforce_install_dir /root/ofsv/tf2\napp_update 232250\nforce_install_dir /root/ofsv/sdk\napp_update 244310\nquit" | sudo tee ~/tf2sdk-update.txt
./steamcmd.sh +runscript ~/tf2sdk-update.txt

# Download Open Fortress
json_data=$(curl -s https://beans.adastral.net/versions.json)

newest_version=$(echo "$json_data" | jq -r '.versions | keys | map(tonumber) | max')

newest_torrent=$(echo "$json_data" | jq -r ".versions.\"$newest_version\".url")
newest_file=$(echo "$json_data" | jq -r ".versions.\"$newest_version\".file" | cut -d '.' -f1)

download_command="aria2c --max-connection-per-server=16 -Ubeans-master --disable-ipv6=true --max-concurrent-downloads=16 --optimize-concurrent-downloads=true --check-certificate=false --check-integrity=true --auto-file-renaming=false --continue=true --allow-overwrite=true --console-log-level=error --summary-interval=0 --bt-hash-check-seed=false --allow-piece-length-change=true --seed-time=0 -d/tmp https://beans.adastral.net/$newest_torrent"

while [ ! -f /tmp/of*.tar.zstd ]; do
  echo "Downloading..."
  $download_command
  sleep 5
done

# Decompress Open Fortress
unzstd /tmp/$newest_file.tar.zstd
rm /tmp/$newest_file.tar.zstd
cd /tmp
tar -xvf /tmp/$newest_file.tar
rm /tmp/$newest_file.tar
mv /tmp/open_fortress ~/ofsv/sdk/open_fortress

# Symlink libraries
cd ~/ofsv/sdk/bin/ && \
  ln -s datacache_srv.so datacache.so && \
  ln -s dedicated_srv.so dedicated.so && \
  ln -s engine_srv.so engine.so && \
  ln -s materialsystem_srv.so materialsystem.so && \
  ln -s replay_srv.so replay.so && \
  ln -s scenefilecache_srv.so scenefilecache.so && \
  ln -s shaderapiempty_srv.so shaderapiempty.so && \
  ln -s soundemittersystem_srv.so soundemittersystem.so && \
  ln -s studiorender_srv.so studiorender.so && \
  ln -s vphysics_srv.so vphysics.so

cd ~/ofsv/sdk/open_fortress/bin/ && \
  ln -s server.so server_srv.so

# Fix gameinfo.txt to use TF2
sed -i 's+|all_source_engine_paths|..\\Team Fortress 2\\+/root/ofsv/tf2/+g' ~/ofsv/sdk/open_fortress/gameinfo.txt

# Add hostname and start server
echo -n "hostname \"${var.github_username}'s of vanilla server (${var.aws_region})\"" | sudo tee ~/ofsv/sdk/open_fortress/cfg/server.cfg

cd ~/ofsv
screen -dmS of ./sdk/srcds_run -console -game open_fortress -secure -secure -timeout 0 -nobreakpad +map dm_gump
EOT
}