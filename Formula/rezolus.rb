# Brew formula for rezolus.

class Rezolus < Formula
  desc "High-resolution systems telemetry, including multiple recorders and a viewer"
  homepage "https://rezolus.com"
  url "https://github.com/iopsystems/rezolus/archive/refs/tags/v5.13.0.tar.gz"
  sha256 "b50950c4368f95e6f30959e4920e3272d216f74ddd8f42154036b0f8be3eba8a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/rezolus-5.13.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71c0d1dae816901f0986de7a63adbe270002086bbf33dfe33351c3fe9851f294"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11de01fc87fc8a486536984005e675229c07c2ee972b2735b9ed213588314314"
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
