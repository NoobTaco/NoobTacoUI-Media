PACKAGER_URL := https://raw.githubusercontent.com/BigWigsMods/packager/master/release.sh

.PHONY: libs all clean test package

all: test

libs:
	@echo "📥 Updating libraries using BigWigsMods packager..."
	curl -s $(PACKAGER_URL) | bash -s -- -c -d -z
	@if [ -d ".release/NoobTacoUI-Media/Libraries/LibSharedMedia-3.0" ]; then \
		echo "📦 Installing LibSharedMedia-3.0..."; \
		rm -rf Libraries/LibSharedMedia-3.0; \
		cp -r .release/NoobTacoUI-Media/Libraries/LibSharedMedia-3.0 Libraries/; \
		echo "✅ Libraries updated successfully!"; \
	else \
		echo "❌ Failed to update libraries"; \
		exit 1; \
	fi
	@rm -rf .release

package:
	@echo "📦 Building addon package with version replacement..."
	@echo "Current git version: $$(git describe --tags --always)"
	curl -s $(PACKAGER_URL) | bash -s -- -d -z
	@echo "✅ Package created in .release directory"

clean:
	@echo "🧹 Cleaning up temporary files..."
	@rm -rf .release .pkgmeta

test:
	@echo "🧪 Testing addon structure..."
	@if [ -f "NoobTacoUI-Media.toc" ]; then \
		echo "✅ TOC file exists"; \
	else \
		echo "❌ TOC file missing"; \
		exit 1; \
	fi
	@if [ -f "Libraries/LibSharedMedia-3.0/LibSharedMedia-3.0/LibSharedMedia-3.0.lua" ]; then \
		echo "✅ LibSharedMedia-3.0 properly installed"; \
	else \
		echo "❌ LibSharedMedia-3.0 missing or incomplete"; \
		exit 1; \
	fi
	@echo "Current git version: $$(git describe --tags --always)"
	@echo "✅ All tests passed!"
