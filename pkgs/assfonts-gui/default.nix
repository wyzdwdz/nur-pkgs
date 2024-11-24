{ stdenv, lib, appimageTools }:

appimageTools.wrapType2 rec {
  version = "0.7.3";
  pname = "assfonts-gui";
  name = "${pname}-${version}";

  arch =
    if stdenv.system == "x86_64-linux" then "x86_64"
    else if stdenv.system == "i686-linux" then "i686"
    else if stdenv.system == "aarch64-linux" then "aarch64"
    else abort ("Unsupported platform");

  sha256Arch = 
    if stdenv.system == "x86_64-linux" then "0y46kn9arglggki5qwzrzvk8gjxxxkvyp3gr2134jdk9c8ykifmd"
    else if stdenv.system == "i686-linux" then "12m4rqrf3iwa33jvh9s3p7yshd8b1jkdsvrlxgqdphrr3zd83jw3"
    else if stdenv.system == "aarch64-linux" then "0jgwbsl7z8mghymfm2r2gvb2114axihs8b1ghqp7mx6fshxw9vhi"
    else abort ("Unsupported platform");

  tarSrc = fetchTarball {
    url =
      "https://github.com/wyzdwdz/assfonts/releases/download/v${version}/assfonts-v${version}-${arch}-Linux.tar.gz";
    sha256 = sha256Arch;
  };

  src = "${tarSrc}/assfonts-gui.AppImage";

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/assfonts-gui.desktop -t $out/share/applications
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "Subset fonts and embed them into an ASS subtitle (GUI version)";
    homepage = "https://github.com/wyzdwdz/assfonts";
    license = lib.licenses.gpl3;
    platforms = platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "assfonts-gui";
  };
}