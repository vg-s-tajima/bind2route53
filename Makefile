BUNDLE_INSTALL_PATH := vendor/bundle

setup:
	bundle install --path $(BUNDLE_INSTALL_PATH)

.PHONY: test
test:
	./test/exec_all_tests.sh

travis: test
