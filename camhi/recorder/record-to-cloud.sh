#!/usr/bin/env bash
# Непрерывная запись RTSP-потока камеры сегментами + выгрузка в облако.
#
# Пишет без перекодирования (-c copy): нулевая нагрузка на CPU, качество 1:1.
# Старые локальные сегменты удаляются после успешной загрузки в облако.
#
# Требуется: ffmpeg, rclone (настроенный remote).
# Правь переменные ниже под свою камеру и облако.
set -euo pipefail

# --- настройки ---
RTSP_URL="${RTSP_URL:-rtsp://admin:password@192.168.1.50:554/11}"
SEGMENT_SECONDS="${SEGMENT_SECONDS:-300}"          # длина одного файла, сек
LOCAL_DIR="${LOCAL_DIR:-/var/lib/camhi/segments}"  # буфер на диске
RCLONE_REMOTE="${RCLONE_REMOTE:-cloud:camhi/cam1}"  # куда в облако
KEEP_LOCAL_MIN="${KEEP_LOCAL_MIN:-30}"             # не трогать файлы свежее N мин
# -----------------

mkdir -p "$LOCAL_DIR"

# Писать поток сегментами. strftime даёт имена по времени.
ffmpeg -nostdin -rtsp_transport tcp -i "$RTSP_URL" \
  -c copy -f segment \
  -segment_time "$SEGMENT_SECONDS" \
  -segment_format mp4 \
  -strftime 1 \
  -reset_timestamps 1 \
  "$LOCAL_DIR/%Y-%m-%d_%H-%M-%S.mp4" &
FFMPEG_PID=$!

# Параллельно: каждые 60с заливаем завершённые сегменты в облако и чистим.
cleanup() { kill "$FFMPEG_PID" 2>/dev/null || true; }
trap cleanup EXIT

while kill -0 "$FFMPEG_PID" 2>/dev/null; do
  # заливаем всё, кроме файла, в который сейчас пишется (свежее KEEP_LOCAL_MIN)
  rclone move "$LOCAL_DIR" "$RCLONE_REMOTE" \
    --min-age "${KEEP_LOCAL_MIN}m" \
    --include "*.mp4" \
    --transfers 2 --no-traverse 2>/dev/null || true
  sleep 60
done
