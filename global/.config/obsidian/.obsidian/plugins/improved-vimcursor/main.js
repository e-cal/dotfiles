var __create = Object.create;
var __defProp = Object.defineProperty;
var __getOwnPropDesc = Object.getOwnPropertyDescriptor;
var __getOwnPropNames = Object.getOwnPropertyNames;
var __getProtoOf = Object.getPrototypeOf;
var __hasOwnProp = Object.prototype.hasOwnProperty;
var __markAsModule = (target) => __defProp(target, "__esModule", { value: true });
var __export = (target, all) => {
  __markAsModule(target);
  for (var name in all)
    __defProp(target, name, { get: all[name], enumerable: true });
};
var __reExport = (target, module2, desc) => {
  if (module2 && typeof module2 === "object" || typeof module2 === "function") {
    for (let key of __getOwnPropNames(module2))
      if (!__hasOwnProp.call(target, key) && key !== "default")
        __defProp(target, key, { get: () => module2[key], enumerable: !(desc = __getOwnPropDesc(module2, key)) || desc.enumerable });
  }
  return target;
};
var __toModule = (module2) => {
  return __reExport(__markAsModule(__defProp(module2 != null ? __create(__getProtoOf(module2)) : {}, "default", module2 && module2.__esModule && "default" in module2 ? { get: () => module2.default, enumerable: true } : { value: module2, enumerable: true })), module2);
};
var __async = (__this, __arguments, generator) => {
  return new Promise((resolve, reject) => {
    var fulfilled = (value) => {
      try {
        step(generator.next(value));
      } catch (e) {
        reject(e);
      }
    };
    var rejected = (value) => {
      try {
        step(generator.throw(value));
      } catch (e) {
        reject(e);
      }
    };
    var step = (x) => x.done ? resolve(x.value) : Promise.resolve(x.value).then(fulfilled, rejected);
    step((generator = generator.apply(__this, __arguments)).next());
  });
};

// main.ts
__export(exports, {
  default: () => ImprovedVimCursor
});
var import_obsidian = __toModule(require("obsidian"));
var ImprovedVimCursor = class extends import_obsidian.Plugin {
  onload() {
    return __async(this, null, function* () {
      this.setup();
      this.registerEvent(this.app.workspace.on("file-open", () => {
        this.setup();
      }));
    });
  }
  setup() {
    let view = this.app.workspace.getActiveViewOfType(import_obsidian.MarkdownView);
    if (!view) {
      return;
    }
    CodeMirror.Vim.defineEx("g0", false, (cm) => {
      cm.execCommand("goLineLeftSmart");
    });
    CodeMirror.Vim.defineEx("gDollar", false, (cm) => {
      cm.execCommand("goLineRight");
    });
    CodeMirror.Vim.defineEx("pHead", false, (cm) => {
      const { line } = cm.getCursor();
      const text = cm.getValue();
      const split = text.split("\n");
      let last = 0;
      for (let i = 0; i < line; i++) {
        const text2 = split[i];
        if (text2.match(/^#{1,6} /)) {
          last = i;
        }
      }
      cm.setCursor(last, 0);
    });
    CodeMirror.Vim.defineEx("nHead", false, (cm) => {
      const { line } = cm.getCursor();
      const text = cm.getValue();
      const split = text.split("\n");
      let last = split.length - 1;
      for (let i = last; i > line; i--) {
        const text2 = split[i];
        if (text2.match(/^#{1,6} /)) {
          last = i;
        }
      }
      cm.setCursor(last, 0);
    });
  }
};
//# sourceMappingURL=data:application/json;base64,ewogICJ2ZXJzaW9uIjogMywKICAic291cmNlcyI6IFsibWFpbi50cyJdLAogICJzb3VyY2VzQ29udGVudCI6IFsiaW1wb3J0IHtNYXJrZG93blZpZXcsIFBsdWdpbn0gZnJvbSAnb2JzaWRpYW4nO1xyXG5cclxuZGVjbGFyZSBjb25zdCBDb2RlTWlycm9yOiBhbnk7XHJcblxyXG5leHBvcnQgZGVmYXVsdCBjbGFzcyBJbXByb3ZlZFZpbUN1cnNvciBleHRlbmRzIFBsdWdpbiB7XHJcbiAgYXN5bmMgb25sb2FkKCkge1xyXG4gICAgdGhpcy5zZXR1cCgpXHJcblxyXG4gICAgdGhpcy5yZWdpc3RlckV2ZW50KHRoaXMuYXBwLndvcmtzcGFjZS5vbignZmlsZS1vcGVuJywgKCkgPT4ge1xyXG4gICAgICB0aGlzLnNldHVwKCk7XHJcbiAgICB9KSk7XHJcbiAgfVxyXG5cclxuICBzZXR1cCgpIHtcclxuICAgIGxldCB2aWV3ID0gdGhpcy5hcHAud29ya3NwYWNlLmdldEFjdGl2ZVZpZXdPZlR5cGUoTWFya2Rvd25WaWV3KVxyXG4gICAgaWYoIXZpZXcpIHtcclxuICAgICAgcmV0dXJuXHJcbiAgICB9XHJcblxyXG4gICAgQ29kZU1pcnJvci5WaW0uZGVmaW5lRXgoXCJnMFwiLCBmYWxzZSwgKGNtOiBDb2RlTWlycm9yLkVkaXRvcikgPT4ge1xyXG4gICAgICBjbS5leGVjQ29tbWFuZChcImdvTGluZUxlZnRTbWFydFwiKTtcclxuICAgIH0pXHJcblxyXG4gICAgQ29kZU1pcnJvci5WaW0uZGVmaW5lRXgoXCJnRG9sbGFyXCIsIGZhbHNlLCAoY206IENvZGVNaXJyb3IuRWRpdG9yKSA9PiB7XHJcbiAgICAgIGNtLmV4ZWNDb21tYW5kKFwiZ29MaW5lUmlnaHRcIik7XHJcbiAgICB9KVxyXG5cclxuICAgIENvZGVNaXJyb3IuVmltLmRlZmluZUV4KFwicEhlYWRcIiwgZmFsc2UsIChjbTogQ29kZU1pcnJvci5FZGl0b3IpID0+IHtcclxuICAgICAgY29uc3QgeyBsaW5lIH0gPSAgY20uZ2V0Q3Vyc29yKClcclxuICAgICAgY29uc3QgdGV4dCA9IGNtLmdldFZhbHVlKClcclxuICAgICAgY29uc3Qgc3BsaXQgPSB0ZXh0LnNwbGl0KFwiXFxuXCIpO1xyXG5cclxuICAgICAgbGV0IGxhc3QgPSAwO1xyXG4gICAgICBmb3IgKGxldCBpID0gMDsgaSA8IGxpbmU7IGkrKykge1xyXG4gICAgICAgIGNvbnN0IHRleHQgPSBzcGxpdFtpXTtcclxuICAgICAgICBpZiAodGV4dC5tYXRjaCgvXiN7MSw2fSAvKSkge1xyXG4gICAgICAgICAgbGFzdCA9IGk7XHJcbiAgICAgICAgfVxyXG4gICAgICB9XHJcbiAgICAgIGNtLnNldEN1cnNvcihsYXN0LCAwKTtcclxuICAgIH0pXHJcblxyXG4gICAgQ29kZU1pcnJvci5WaW0uZGVmaW5lRXgoXCJuSGVhZFwiLCBmYWxzZSwgKGNtOiBDb2RlTWlycm9yLkVkaXRvcikgPT4ge1xyXG4gICAgICBjb25zdCB7IGxpbmUgfSA9ICBjbS5nZXRDdXJzb3IoKVxyXG4gICAgICBjb25zdCB0ZXh0ID0gY20uZ2V0VmFsdWUoKVxyXG4gICAgICBjb25zdCBzcGxpdCA9IHRleHQuc3BsaXQoXCJcXG5cIik7XHJcblxyXG4gICAgICBsZXQgbGFzdCA9IHNwbGl0Lmxlbmd0aCAtIDE7XHJcbiAgICAgIGZvciAobGV0IGkgPSBsYXN0OyBpID4gbGluZTsgaS0tKSB7XHJcbiAgICAgICAgY29uc3QgdGV4dCA9IHNwbGl0W2ldO1xyXG4gICAgICAgIGlmICh0ZXh0Lm1hdGNoKC9eI3sxLDZ9IC8pKSB7XHJcbiAgICAgICAgICBsYXN0ID0gaTtcclxuICAgICAgICB9XHJcbiAgICAgIH1cclxuICAgICAgY20uc2V0Q3Vyc29yKGxhc3QsIDApO1xyXG4gICAgfSlcclxuICB9XHJcbn1cclxuIl0sCiAgIm1hcHBpbmdzIjogIjs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7O0FBQUE7QUFBQTtBQUFBO0FBQUEsc0JBQW1DO0FBSW5DLHNDQUErQyx1QkFBTztBQUFBLEVBQzlDLFNBQVM7QUFBQTtBQUNiLFdBQUs7QUFFTCxXQUFLLGNBQWMsS0FBSyxJQUFJLFVBQVUsR0FBRyxhQUFhLE1BQU07QUFDMUQsYUFBSztBQUFBO0FBQUE7QUFBQTtBQUFBLEVBSVQsUUFBUTtBQUNOLFFBQUksT0FBTyxLQUFLLElBQUksVUFBVSxvQkFBb0I7QUFDbEQsUUFBRyxDQUFDLE1BQU07QUFDUjtBQUFBO0FBR0YsZUFBVyxJQUFJLFNBQVMsTUFBTSxPQUFPLENBQUMsT0FBMEI7QUFDOUQsU0FBRyxZQUFZO0FBQUE7QUFHakIsZUFBVyxJQUFJLFNBQVMsV0FBVyxPQUFPLENBQUMsT0FBMEI7QUFDbkUsU0FBRyxZQUFZO0FBQUE7QUFHakIsZUFBVyxJQUFJLFNBQVMsU0FBUyxPQUFPLENBQUMsT0FBMEI7QUFDakUsWUFBTSxFQUFFLFNBQVUsR0FBRztBQUNyQixZQUFNLE9BQU8sR0FBRztBQUNoQixZQUFNLFFBQVEsS0FBSyxNQUFNO0FBRXpCLFVBQUksT0FBTztBQUNYLGVBQVMsSUFBSSxHQUFHLElBQUksTUFBTSxLQUFLO0FBQzdCLGNBQU0sUUFBTyxNQUFNO0FBQ25CLFlBQUksTUFBSyxNQUFNLGFBQWE7QUFDMUIsaUJBQU87QUFBQTtBQUFBO0FBR1gsU0FBRyxVQUFVLE1BQU07QUFBQTtBQUdyQixlQUFXLElBQUksU0FBUyxTQUFTLE9BQU8sQ0FBQyxPQUEwQjtBQUNqRSxZQUFNLEVBQUUsU0FBVSxHQUFHO0FBQ3JCLFlBQU0sT0FBTyxHQUFHO0FBQ2hCLFlBQU0sUUFBUSxLQUFLLE1BQU07QUFFekIsVUFBSSxPQUFPLE1BQU0sU0FBUztBQUMxQixlQUFTLElBQUksTUFBTSxJQUFJLE1BQU0sS0FBSztBQUNoQyxjQUFNLFFBQU8sTUFBTTtBQUNuQixZQUFJLE1BQUssTUFBTSxhQUFhO0FBQzFCLGlCQUFPO0FBQUE7QUFBQTtBQUdYLFNBQUcsVUFBVSxNQUFNO0FBQUE7QUFBQTtBQUFBOyIsCiAgIm5hbWVzIjogW10KfQo=
