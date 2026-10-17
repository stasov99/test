#!/usr/bin/env python3
"""Опросить CamHi/Hichip-камеру по ONVIF: профили, RTSP-URI, разрешение.

Работает только с твоей камерой в твоей сети.

Использование:
    pip install onvif-zeep
    python3 onvif_probe.py <ip> <onvif_port> <user> <password>

Порт ONVIF у Hichip обычно 8080 (иногда 80 или 8000).
"""
import sys

try:
    from onvif import ONVIFCamera
except ImportError:
    sys.exit("Нет onvif-zeep. Установи: pip install onvif-zeep")


def main() -> int:
    if len(sys.argv) != 5:
        sys.exit(__doc__)
    ip, port, user, pwd = sys.argv[1], int(sys.argv[2]), sys.argv[3], sys.argv[4]

    cam = ONVIFCamera(ip, port, user, pwd)
    media = cam.create_media_service()

    for profile in media.GetProfiles():
        name = profile.Name
        token = profile.token
        enc = getattr(profile, "VideoEncoderConfiguration", None)

        print(f"\n=== Профиль: {name} (token={token}) ===")
        if enc is not None:
            res = enc.Resolution
            print(f"  Кодек:      {enc.Encoding}")
            print(f"  Разрешение: {res.Width}x{res.Height}")
            print(f"  FPS:        {enc.RateControl.FrameRateLimit}")
            print(f"  Битрейт:    {enc.RateControl.BitrateLimit} kbps")

        req = media.create_type("GetStreamUri")
        req.ProfileToken = token
        req.StreamSetup = {
            "Stream": "RTP-Unicast",
            "Transport": {"Protocol": "RTSP"},
        }
        uri = media.GetStreamUri(req)
        print(f"  RTSP URI:   {uri.Uri}")

    print("\nСовет: профиль с наибольшим разрешением — основной (high quality).")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
