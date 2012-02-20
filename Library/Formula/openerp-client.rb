require 'formula'

class OpenerpClient < Formula
  homepage 'http://www.openerp.com/'
  url 'http://www.openerp.com/download/stable/source/openerp-client-6.0.3.tar.gz'
  md5 '81d96ef7fb7650d77c00f4f135a60c5f'

  depends_on 'cairo'
  depends_on 'gtk+'
  depends_on 'gdk-pixbuf'
  depends_on 'pango'
  depends_on 'py2cairo'
  depends_on 'libffi'
  depends_on 'glade'
  depends_on 'pygtk'

  def install
    system "chmod a+x configure"
    system "python /Library/Python/2.7/site-packages/virtualenv.py --distribute ~/env/openerp"
    system 'echo "/usr/local/lib/python2.7/site-packages/" >> ~/env/openerp/lib/python2.7/site-packages/brew_path.pth'
    system 'echo "/usr/local/lib/python2.7/site-packages/gtk-2.0/" >> ~/env/openerp/lib/python2.7/site-packages/brew_path.pth'
    system "./configure", "--prefix=#{prefix}"
    system "~/env/openerp/bin/pip install lxml pydot python-dateutil"
    system ". ~/env/openerp/bin/activate && make install"
    system "cat > #{bin}/openerp-client << EOF
#!/bin/sh
cd #{prefix}/lib/python2.7/site-packages/openerp-client
exec ~/env/openerp/bin/python ./openerp-client.py $@
EOF
"
  end

  def test
    system "#{bin}/openerp-client"
  end
end
