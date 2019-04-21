{ stdenv, fetchurl, pkgconfig, intltool, gtk3, libnotify, libxml2, libexif, exempi, mate, hicolor-icon-theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "caja-${version}";
  version = "1.22.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "14x9n9q7vip5zp4mdgccj1p1dm4xn429g0bjw2v8iz7zmjb7vcgl";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    libnotify
    libxml2
    libexif
    exempi
    mate.mate-desktop
    hicolor-icon-theme
  ];

  patches = [
    ./caja-extension-dirs.patch
  ];

  configureFlags = [ "--disable-update-mimedb" ];

  meta = {
    description = "File manager for the MATE desktop";
    homepage = https://mate-desktop.org;
    license = with stdenv.lib.licenses; [ gpl2 lgpl2 ];
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
