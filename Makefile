cefdir = /opt/oblong/deps-64-12/cef3112
kind = Release
tiny: tiny.mm
	clang++ -stdlib=libc++ --std=c++11 -Wno-deprecated-declarations \
            -I $(cefdir) \
            -L $(cefdir)/$(kind)/lib \
            -F$(cefdir)/$(kind)/cefclient.app/Contents/Frameworks -framework Chromium\ Embedded\ Framework \
            -framework Cocoa tiny.mm -o tiny -l cef_dll_wrapper
	rm -rf tiny.app
	mkdir -p "tiny.app/Contents/Frameworks"
	mkdir -p "tiny.app/Contents/MacOS"
	install -m 755 tiny "tiny.app/Contents/MacOS"
	ln -sf "$(cefdir)/$(kind)/Chromium Embedded Framework.framework/Resources" "tiny.app/Contents/."
	ln -s "$(cefdir)/$(kind)/cefclient.app/Contents/Frameworks/Chromium Embedded Framework.framework" "tiny.app/Contents/Frameworks"
	cp -a "$(cefdir)/$(kind)/cefclient.app/Contents/Frameworks/cefclient Helper.app" "tiny.app/Contents/Frameworks/tiny Helper.app"
	sed -i.bak "s/cefclient/tiny/"  "tiny.app/Contents/Frameworks/tiny Helper.app/Contents/Info.plist"
	mv "tiny.app/Contents/Frameworks/tiny Helper.app/Contents/MacOS/cefclient Helper" "tiny.app/Contents/Frameworks/tiny Helper.app/Contents/MacOS/tiny Helper"

run: tiny
	# See https://bitbucket.org/chromiumembedded/cef/issues/1936/override-paths-dir_exe-dir_module-on-linux
	# https://github.com/chromiumembedded/cef/pull/4
	tiny.app/Contents/MacOS/tiny

debug: tiny
	lldb tiny.app/Contents/MacOS/tiny

clean:
	rm -rf tiny tiny.app
