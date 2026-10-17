#!/usr/bin/env bash
# Разбор APK приложения CamHi/CamHiPro: найти нативные P2P-библиотеки и
# строки протокола. Только для исследования доступа к СВОИМ камерам, когда
# камера не отдаёт RTSP и прошивку сменить нельзя.
#
# Использование: analyze_apk.sh CamHi.apk
set -euo pipefail

APK="${1:?укажи путь к .apk}"
OUT="$(mktemp -d)"
echo "Распаковка в $OUT"

unzip -q "$APK" -d "$OUT"

echo
echo "=== Нативные библиотеки (ищем P2P-движок) ==="
find "$OUT/lib" -name '*.so' 2>/dev/null | sort

echo
echo "=== Библиотеки с признаками PPPP/P2P ==="
for so in $(find "$OUT/lib" -name '*.so' 2>/dev/null); do
  if strings "$so" 2>/dev/null | grep -Eqi 'PPPP|P2P|init_string|DSK|CS2|32100'; then
    echo ">>> $so"
    strings "$so" | grep -Ei 'PPPP|P2P_|init_string|DSK|CS2|rtsp|h264|h265' | sort -u | head -40
    echo
  fi
done

echo "Готово. Дальше: Frida-хуки на функции P2P-библиотеки (frida/)."
echo "Каталог со вскрытым APK: $OUT"
