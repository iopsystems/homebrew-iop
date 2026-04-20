# Brew formula for rezolus.

class Rezolus < Formula
  desc "High-resolution systems telemetry, including multiple recorders and a viewer"
  homepage "https://rezolus.com"
  url "https://github.com/iopsystems/rezolus/archive/refs/tags/v5.10.0.tar.gz"
  sha256 "c8a7e15f850a00f8be17038fb2dde4284f5105fe2a494afe98da5607051ce394"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/rezolus-5.10.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "498f23dad71f09568a7cab8b817b9bbf5677f21d62be94c83f1b31fee870a604"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a323730c402238a0b81db1f90e73daacb979fb5bf691b213c2a8c085cba61a86"
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
