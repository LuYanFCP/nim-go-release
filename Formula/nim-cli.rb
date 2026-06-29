class NimCli < Formula
  desc "CLI for running NVIDIA NIM containers"
  homepage "https://github.com/LuYanFCP/nim-go-release"
  version "latest"
  license "Apache-2.0"

  depends_on :linux

  conflicts_with "nim", because: "both install a `nim` executable"

  livecheck do
    url "https://github.com/LuYanFCP/nim-go-release"
    regex(/^v?(.+)$/i)
    strategy :github_latest
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/LuYanFCP/nim-go-release/releases/latest/download/nim-linux-arm64",
          using: :nounzip
      sha256 :no_check
    elsif Hardware::CPU.intel?
      url "https://github.com/LuYanFCP/nim-go-release/releases/latest/download/nim-linux-amd64",
          using: :nounzip
      sha256 :no_check
    end
  end

  def install
    bin.install cached_download => "nim"
    chmod 0755, bin/"nim"
  end

  test do
    system bin/"nim", "--help"
  end
end
