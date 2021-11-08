# brew install platypus
# brew install poppler (pdftopngのため)

.PHONY: drawer danshari

space:
	/bin/rm -r -f Space.app
	cp bin/space .
	platypus --name Space --interpreter /usr/bin/ruby --quit-after-execution --droppable --interface-type None --app-icon space.icns space
	mv Space.app masui-space.app

danshari:
	/bin/rm -r -f Danshari.app
	cp bin/danshari .
	platypus --name Danshari --interpreter /usr/bin/ruby --quit-after-execution --droppable --interface-type None --app-icon danshari.icns danshari

#	platypus --name Danshari --interpreter /usr/bin/ruby --droppable --interface-type 'Text Window' --app-icon danshari.icns danshari
