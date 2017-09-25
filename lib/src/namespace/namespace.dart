library grizzly.vizdom.namespace;

class NameSpaced {
  final String namespace;

  final String local;

  bool get hasSpace => namespace != null;

  String get space => namespace != null ? namespaces[namespace] : null;

  NameSpaced(this.namespace, this.local);

  NameSpaced.noSpace(this.local) : namespace = null;

  static const Map<String, String> namespaces = const <String, String>{
    'svg': 'http://www.w3.org/2000/svg',
    'xhtml': 'http://www.w3.org/1999/xhtml',
    'xlink': 'http://www.w3.org/1999/xlink',
    'xml': 'http://www.w3.org/XML/1998/namespace',
    'xmlns': 'http://www.w3.org/2000/xmlns/'
  };

  static String nameSVG = 'svg';

  static String nameXHTML = 'xhtml';

  static NameSpaced parse(String name) {
    final List<String> parts = name.split(':');

    if (parts.length == 1 || parts.first == 'xmlns')
      return new NameSpaced.noSpace(name);

    return new NameSpaced(parts.first, parts.sublist(1).join(':'));
  }
}
