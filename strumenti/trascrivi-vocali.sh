#!/bin/zsh
# Trascrive in italiano tutte le note vocali di un'esportazione di Telegram.
# Uso: ./trascrivi-vocali.sh "/percorso/cartella/esportazione"
# Per ogni audio crea un file .txt accanto, con lo stesso nome. Gli audio già trascritti vengono saltati.

set -e
DIR="${1:?Indica la cartella dell'esportazione di Telegram}"
MODEL="$HOME/whisper-models/ggml-large-v3-turbo-q5_0.bin"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

find "$DIR" -type f \( -iname '*.ogg' -o -iname '*.oga' -o -iname '*.opus' -o -iname '*.m4a' -o -iname '*.mp3' \) | sort | while read -r f; do
  out="${f%.*}.txt"
  [[ -s "$out" ]] && continue
  echo "Trascrivo: ${f:t}"
  ffmpeg -y -loglevel error -i "$f" -ar 16000 -ac 1 "$TMP/a.wav"
  whisper-cli -m "$MODEL" -l it -nt -np -f "$TMP/a.wav" 2>/dev/null | sed 's/^ *//' > "$out"
done
echo "Fatto."
