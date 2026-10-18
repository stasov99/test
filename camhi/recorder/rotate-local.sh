#!/usr/bin/env bash
# Ротация локального архива: удалять записи старше RETENTION_DAYS.
# Для варианта «без облака» — запись на локальный диск мини-ПК.
# Запускать по cron раз в час.
#
# Переменные можно задать в cameras.env или через окружение.
set -euo pipefail

REC_DIR="${REC_DIR:?укажи REC_DIR — папку с записями рекордера}"
RETENTION_DAYS="${RETENTION_DAYS:-14}"

# удалить файлы записей старше N дней
find "$REC_DIR" -type f \
  \( -iname '*.mp4' -o -iname '*.mkv' -o -iname '*.avi' \
     -o -iname '*.264' -o -iname '*.h264' -o -iname '*.h265' \) \
  -mtime +"$RETENTION_DAYS" -print -delete

# подчистить опустевшие подпапки
find "$REC_DIR" -mindepth 1 -type d -empty -delete 2>/dev/null || true

# предупредить, если на диске осталось мало места (<20 ГБ)
avail_gb=$(df -P "$REC_DIR" | awk 'NR==2{print int($4/1024/1024)}')
if [ "${avail_gb:-0}" -lt 20 ]; then
  echo "ВНИМАНИЕ: на диске с записями осталось ${avail_gb} ГБ — уменьши RETENTION_DAYS" >&2
fi

echo "$(date '+%F %T') rotate ok (хранение ${RETENTION_DAYS}д, свободно ${avail_gb}ГБ)"
