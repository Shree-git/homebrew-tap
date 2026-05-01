class Claw < Formula
  desc "Claw VCS: intent-native, agent-native version control."
  homepage "https://github.com/shree-git/claw-vcs"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/shree-git/claw-vcs/releases/download/v0.1.0/claw-aarch64-apple-darwin.tar.xz"
      sha256 "8953576a7032a6359f9f9a73c4fede4710d1b287e2e2ac60daf754431501a714"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shree-git/claw-vcs/releases/download/v0.1.0/claw-x86_64-apple-darwin.tar.xz"
      sha256 "fc1e99766bb9c37b0eb855183ee6c09f0cfb275bdd847c5e9330365fb444e3eb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/shree-git/claw-vcs/releases/download/v0.1.0/claw-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4d3eb15061274aaf90a5010c3cad50c523aff53d638a40a4f281d96972c3609c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shree-git/claw-vcs/releases/download/v0.1.0/claw-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a076b4611c9adc9b498241ec5e480e5c61b6371e22001e32d5337c4d496fef16"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "claw" if OS.mac? && Hardware::CPU.arm?
    bin.install "claw" if OS.mac? && Hardware::CPU.intel?
    bin.install "claw" if OS.linux? && Hardware::CPU.arm?
    bin.install "claw" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
