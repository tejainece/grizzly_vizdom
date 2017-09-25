part of grizzly.vizdom.elements;

abstract class _CommonSvgAttr implements _Base {
	_CommonSvgAttr stroke(String value) {
		selection.attr('stroke', value.toString());
		return this;
	}

	_CommonSvgAttr fill(String value) {
		selection.attr('fill', value.toString());
		return this;
	}
}