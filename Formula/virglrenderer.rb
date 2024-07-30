class Virglrenderer < Formula
  desc "virglrenderer (macos)"
  homepage "https://github.com/akihikodaki/virglrenderer"
  head "https://github.com/akihikodaki/virglrenderer.git", branch: "macos"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end
end
