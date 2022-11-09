  TMP_DIR="/tmp"
  DLINK_ENC_PATH_="$1"
  EXTRACTION_FILE_="$2"
  TMP_IMAGE_FILE="$TMP_DIR/image.bin"

  hexdump -C "$DLINK_ENC_PATH_" | head | tee -a "$LOG_FILE" || true
  dd if="$DLINK_ENC_PATH_" skip=16 iflag=skip_bytes of="$TMP_IMAGE_FILE" 2>&1 | tee -a "$LOG_FILE"

  IMAGE_SIZE=$(stat -c%s "$TMP_IMAGE_FILE")
  (( ROOF=IMAGE_SIZE/131072 ))
  for ((ITERATION=0; ITERATION<ROOF; ITERATION++)); do
    (( OFFSET=131072*ITERATION ))
    dd if="$TMP_IMAGE_FILE" skip="$OFFSET" iflag=skip_bytes count=256| openssl aes-256-cbc -d -in /dev/stdin  -out /dev/stdout \
    -K "6865392d342b4d212964363d6d7e7765312c7132613364316e26322a5a5e2538" -iv "4a253169516c38243d6c6d2d3b384145" --nopad \
    --nosalt | dd if=/dev/stdin of="$EXTRACTION_FILE_" oflag=append conv=notrunc 2>&1 | tee -a "$LOG_FILE"
  done
# Now it should be a .ubi file thats somewhat readable and extractable via ubireader
  echo ""
  if [[ -f "$EXTRACTION_FILE_" ]]; then
    echo "[+] Decrypted D-Link firmware file to $ORANGE$EXTRACTION_FILE_$NC"
    echo ""
    echo "[*] Firmware file details: $ORANGE$(file "$EXTRACTION_FILE_")$NC"
    export FIRMWARE_PATH="$EXTRACTION_FILE_"
  else
    echo "[-] Decryption of D-Link firmware file failed"
  fi

