# Brew formula for rezolus.

class Rezolus < Formula
  desc "High-resolution systems telemetry, including multiple recorders and a viewer"
  homepage "https://rezolus.com"
  url "https://github.com/iopsystems/rezolus/archive/refs/tags/v5.9.1.tar.gz"
  sha256 "27683d145e862e3752b5775a09ca0c1b424ab9631d23fd73c9ffbf3750fa23b1"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/rezolus-5.9.1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "471fc9da27df08c0d9206a3bfd28d2a3ee5b86277a00ad3ef5e421cf353567b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be9e0c1c546aa12fe4e408fbff0a34501a6da1078ee9a6ec78cad809c7c9b4cc"
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
