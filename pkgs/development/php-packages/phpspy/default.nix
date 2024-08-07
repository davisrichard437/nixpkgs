{
  lib,
  stdenv,
  fetchFromGitHub,
  gnugrep,
  binutils,
  makeBinaryWrapper,
  php,
  testers,
  phpPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "phpspy";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "adsr";
    repo = "phpspy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-iQOeZLHRc5yUgXc6xz52t/6oc07eZfH5ZgzSdJBcaak=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    php.unwrapped
  ];

  env.USE_ZEND = 1;

  installPhase = ''
    runHook preInstall

    install -Dt "$out/bin" phpspy stackcollapse-phpspy.pl

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram "$out/bin/phpspy" \
      --prefix PATH : "${
        lib.makeBinPath [
          gnugrep
          # for objdump
          binutils
        ]
      }"
  '';

  passthru.tests.version = testers.testVersion {
    version = "v${finalAttrs.version}";
    package = phpPackages.phpspy;
    command = "phpspy -v";
  };

  meta = with lib; {
    description = "Low-overhead sampling profiler for PHP";
    homepage = "https://github.com/adsr/phpspy";
    license = licenses.mit;
    mainProgram = "phpspy";
    maintainers = with maintainers; [ gaelreyrol ];
    platforms = [ "x86_64-linux" ];
  };
})
