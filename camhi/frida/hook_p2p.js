// Frida-заготовка: перехват нативной P2P-библиотеки CamHi/CamHiPro.
// Цель — увидеть, как приложение инициализирует P2P и где проходит видеопоток,
// чтобы повторить доступ к СВОЕЙ камере без приложения.
//
// Запуск (устройство с root / эмулятор, своя камера):
//   frida -U -f net.hichip.campro -l hook_p2p.js --no-pause
//
// Имя .so уточни через scripts/analyze_apk.sh (часто libPPPP_API.so,
// libvdp.so, libIPCAMClient.so и т.п.).

const LIB = "libPPPP_API.so";

function hookExport(name) {
  const addr = Module.findExportByName(LIB, name);
  if (!addr) { console.log("[-] нет экспорта:", name); return; }
  Interceptor.attach(addr, {
    onEnter(args) {
      this.name = name;
      console.log("\n[>] " + name);
      // первые пара аргументов часто — строки (UID, init-string, креды)
      for (let i = 0; i < 3; i++) {
        try { console.log("    arg" + i + " = " + args[i].readUtf8String()); }
        catch (e) { console.log("    arg" + i + " = " + args[i]); }
      }
    },
    onLeave(ret) {
      console.log("[<] " + this.name + " => " + ret);
    },
  });
}

function main() {
  // типовые имена функций PPPP/CS2-стека — правь под свою библиотеку
  ["PPPP_Initialize", "PPPP_ConnectByServer", "PPPP_Connect",
   "PPPP_Read", "PPPP_Write", "PPPP_Check",
   "P2P_Connect", "P2P_Read", "P2P_Write"].forEach(hookExport);
}

if (Module.findBaseAddress(LIB)) {
  main();
} else {
  // библиотека грузится позже — ждём её
  const dlopen = Module.findExportByName(null, "android_dlopen_ext");
  Interceptor.attach(dlopen, {
    onEnter(args) { this.path = args[0].readUtf8String(); },
    onLeave() { if (this.path && this.path.indexOf(LIB) !== -1) main(); },
  });
}
