# Brew formula for rezolus.

class Rezolus < Formula
  desc "High-resolution systems telemetry, including multiple recorders and a viewer"
  homepage "https://rezolus.com"
  url "https://github.com/iopsystems/rezolus/archive/refs/tags/v5.14.0.tar.gz"
  sha256 "036cb30c9e575a96f85dc04147065f3683bb5465ba16a6ea3c07d3d84a139141"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/rezolus-5.14.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28f0f7d6e96ffa6db6bf90a799358cf52f1ff37e56241cf088efbced8ba63258"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93c2526ca984e1d7635d214726653a1578b807e32524e5bcbaa9e64f3ff8b212"
  end

  depends_on "llvm" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "libelf"
  depends_on "zlib"

  def install
    ENV["CC"] = formula_opt_bin("llvm")/"clang"
    ENV["CXX"] = formula_opt_bin("llvm")/"clang++"
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "rezolus", shell_output("#{bin}/rezolus --version")
  end
end
