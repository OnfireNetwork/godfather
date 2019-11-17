Dialog = Dialog or ImportPackage("dialogui")
_ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end
t = _