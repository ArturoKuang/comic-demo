#!/usr/bin/env sh
set -e
cd "$(dirname "$0")"

mkdir -p dist/assets

# copy every asset except the raw WAV (it ships compressed below)
find assets -maxdepth 1 -type f ! -name '*.wav' -exec cp {} dist/assets/ \;

# re-encode the soundtrack only when the WAV has changed
if [ ! -f dist/assets/steppe-wedding.m4a ] || [ assets/steppe-wedding.wav -nt dist/assets/steppe-wedding.m4a ]; then
  ffmpeg -y -i assets/steppe-wedding.wav -c:a aac -b:a 160k dist/assets/steppe-wedding.m4a
fi

sed 's/steppe-wedding\.wav/steppe-wedding.m4a/' cart-on-the-steppe.html > dist/index.html

echo "build ok -> dist/ ($(du -sh dist | cut -f1))"
