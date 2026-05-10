# Brew formula for rezolus.

class Rezolus < Formula
  desc "High-resolution systems telemetry, including multiple recorders and a viewer"
  homepage "https://rezolus.com"
  url "https://github.com/iopsystems/rezolus/archive/refs/tags/v5.12.1.tar.gz"
  sha256 "76665584b282b8fd8b1123734037ae55a1d04e6981aa488f2b34b8caf11fdafb"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/rezolus-5.12.1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "740f31d7c24cb95ad36c1b67537450fd814d00fbcc2ae1944f19b59862836774"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c7326d97fe292011cf07dd3f102b8c6836e13f5d3edef31b172f6415b4cd72a"
  end

  depends_on "llvm" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "libelf"
  depends_on "zlib"

  def install
    ENV["CC"] = Formula["llvm"].opt_bin/"clang"
    ENV["CXX"] = Formula["llvm"].opt_bin/"clang++"
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "rezolus", shell_output("#{bin}/rezolus --version")
  end
end
