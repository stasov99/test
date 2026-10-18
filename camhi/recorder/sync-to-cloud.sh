#!/usr/bin/env bash
# Выгрузка записей в облако с ротацией (хранение N дней).
# Источник — папка, куда пишет рекордер (HiP2P CMS, CamHi или наш ffmpeg).
# Запускать по cron каждые 5–10 минут ИЛИ как фоновый цикл.
#
# Требуется: rclone (настроенный remote). Переменные берутся из cameras.env.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "${ENV_FILE:-$HERE/cameras.env}"

# Папка, в которую пишет рекордер (у HiP2P — своя папка записи; у нашего
# ffmpeg-рекордера — LOCAL_DIR). Укажи реальный путь:
REC_DIR="${REC_DIR:?укажи REC_DIR — папку с записями рекордера}"

# 1) залить в облако всё, кроме файлов, в которые ещё пишется (свежее 2 мин)
rclone move "$REC_DIR" "$RCLONE_REMOTE" \
  --min-age 2m \
  --include "*.{mp4,mkv,avi,264,h264,h265}" \
  --transfers 3 --checkers 6 --no-traverse

# 2) ротация в облаке: удалить объекты старше RETENTION_DAYS
rclone delete "$RCLONE_REMOTE" \
  --min-age "${RETENTION_DAYS:-14}d" \
  --rmdirs 2>/dev/null || true

echo "$(date '+%F %T') sync ok (retention ${RETENTION_DAYS:-14}d)"
