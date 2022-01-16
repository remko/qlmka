CFLAGS = -Wno-deprecated-declarations

all: MKA.qlgenerator

.PHONY: internal
internal:
	go build -buildmode=c-archive -o internal.a ./internal

.PHONY: MKA.qlgenerator
MKA.qlgenerator: internal
	@mkdir -p MKA.qlgenerator/Contents/MacOS
	clang $(CFLAGS) -framework ImageIO -framework Foundation -framework QuickLook -bundle -o MKA.qlgenerator/Contents/MacOS/MKA main.c generate.m internal.a
	cat Info.plist | sed "s/\$${VERSION}/$$(git describe --tags | cut -b 2-)/" | sed "s/\$${SHORT_VERSION}/$$(git describe --abbrev=0 --tags | cut -b 2-)/" > MKA.qlgenerator/Contents/Info.plist

.PHONY: install
install: MKA.qlgenerator
	rsync -a --delete MKA.qlgenerator/ ~/Library/QuickLook/MKA.qlgenerator/
	qlmanage -r

.PHONY: package
package: MKA.qlgenerator
	zip -r $<.zip $< 

.PHONY: upload-release-binary
upload-release-binary:
	curl --fail-with-body -X POST -H "Authorization: token $(GITHUB_TOKEN)" -H "Content-Type: application/zip" --data-binary "@MKA.qlgenerator.zip" "https://uploads.github.com/repos/$(GITHUB_REPOSITORY)/releases/$(GITHUB_RELEASE_ID)/assets?name=$(BINARY_NAME)&label=$(BINARY_NAME)%20($(BINARY_LABEL))"

.PHONY: clean
clean:
	-rm -rf *.zip *.a internal.h MKA.qlgenerator

##################################################################################################
# Testing
##################################################################################################

test-thumbnail-jpg: test/jpeg.mka 
	/usr/bin/qlmanage -g ./MKA.qlgenerator -c org.matroska.mka -t $<

test-thumbnail-png: test/png.mka 
	/usr/bin/qlmanage -g ./MKA.qlgenerator -c org.matroska.mka -t $<

test-preview: test/jpeg.mka 
	/usr/bin/qlmanage -g ./MKA.qlgenerator -c org.matroska.mka -p $<

test/jpeg.mka: test/cover.jpg
	ffmpeg -loglevel quiet -y -t 1 -f lavfi -i anullsrc=channel_layout=stereo:sample_rate=44100 -c:a aac -attach $< -metadata:s:t mimetype=image/jpeg $@

test/png.mka: test/cover.png
	ffmpeg -loglevel quiet -y -t 1 -f lavfi -i anullsrc=channel_layout=stereo:sample_rate=44100 -c:a aac -attach $< -metadata:s:t mimetype=image/png $@
