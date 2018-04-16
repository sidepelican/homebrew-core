class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "http://quantlib.org/"
  url "https://dl.bintray.com/quantlib/releases/QuantLib-1.12.1.tar.gz"
  sha256 "92b92b3db842da20db6fc5eba1e75baecaa62f6b19f1eb1e6568ce7d7df927cc"

  bottle do
    cellar :any
    sha256 "fa5685622228bb6adf2281b4b127812c648bf2e68c2a104dbd774f1a9629a4a6" => :high_sierra
    sha256 "b69fa78857c6b943ff79585a729e4efaeb3ebb5759fc649494c66a1e05343dee" => :sierra
    sha256 "2821d4e052de582848da61e7c7e08ce85c9eed211f8f7dcd685232b4fd2281d0" => :el_capitan
  end

  head do
    url "https://github.com/lballabio/quantlib.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option "with-intraday", "Enable intraday components to dates"

  depends_on "boost"

  def install
    (buildpath/"QuantLib").install buildpath.children if build.stable?
    cd "QuantLib" do
      system "./autogen.sh" if build.head?
      args = []
      args << "--enable-intraday" if build.with? "intraday"
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-lispdir=#{elisp}",
                            *args

      system "make", "install"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"quantlib-config", "--prefix=#{prefix}", "--libs", "--cflags"
  end
end
