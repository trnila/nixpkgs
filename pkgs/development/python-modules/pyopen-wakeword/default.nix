{
  lib,
  stdenv,
  autoPatchelfHook,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  tensorflow-lite,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyopen-wakeword";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "pyopen-wakeword";
    tag = "v${version}";
    hash = "sha256-czFDuIZ10aetr6frkKSozPjS7zMeNJ5/WVLA7Ib1CaI=";
  };

  postPatch = ''
    # remove pre-compiled libtensorflowlite
    rm -r ./lib

    # replace path to tensorflow-lite from nix
    substituteInPlace pyopen_wakeword/openwakeword.py \
      --replace-fail "_MODULE_LIB_DIR = _DIR / \"lib\"" "_MODULE_LIB_DIR = Path(\"${tensorflow-lite}/lib\")"
  '';

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    tensorflow-lite
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyopen_wakeword"
  ];

  meta = {
    description = "Alternative Python library for openWakeWord";
    homepage = "https://github.com/rhasspy/pyopen-wakeword";
    changelog = "https://github.com/rhasspy/pyopen-wakeword/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
