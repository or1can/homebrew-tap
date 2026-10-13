class RatectCompat < Formula
  desc "A strict, flag-for-flag and field-for-field drop-in replacement for the (now-unmaintained) batect binary"
  homepage "https://github.com/or1can/ratect"
  version "0.32.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/or1can/ratect/releases/download/ratect-compat/v0.32.0/ratect-compat-aarch64-apple-darwin.tar.xz"
      sha256 "2904ba54085df42c7f08e28cbf87fe66c0a7543a1c80ccffdf3526ab65a7f668"
    end
    if Hardware::CPU.intel?
      url "https://github.com/or1can/ratect/releases/download/ratect-compat/v0.32.0/ratect-compat-x86_64-apple-darwin.tar.xz"
      sha256 "697818264ea2c548f428b375e68e62c39aa4444c74a42a5e3ecaf397096e84ee"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/or1can/ratect/releases/download/ratect-compat/v0.32.0/ratect-compat-aarch64-unknown-linux-musl.tar.xz"
      sha256 "61ae5d3d3eda139b730a2f14abbbdc3a0e74bb67fa034b3fcd0fa093b990d1aa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/or1can/ratect/releases/download/ratect-compat/v0.32.0/ratect-compat-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "60c20f8fd66301ca6fb1882208650b2152f8a62ed0646706f94fc860bd080976"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "ratect-compat"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "ratect-compat"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "ratect-compat"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "ratect-compat"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
