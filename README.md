# VizDOM

Fluent data driven documents based selection and data-join API for HTML DOM

# Examples

## Selection

TBD

## Transition

### Control

```dart
void main() {
  final anim = new AnimationBuilder().duration(120000).fillForwards()
    ..createAt(0.0).translateX(0)
    ..createAt(1.0).translateX(1000);

  select('#root')
      .selectAll('div')
      .style('background-color', 'red')
      .transition('anim1')
      .animateWithBuilder(anim);

  querySelector('#btn-cancel').onClick.listen((_) {
    select('#root').selectAll('div').transition('anim1').cancel();
  });

  querySelector('#btn-start').onClick.listen((_) {
    select('#root')
        .selectAll('div')
        .transition('anim1')
        .animateWithBuilder(anim);
  });

  querySelector('#btn-reverse').onClick.listen((_) {
    select('#root').selectAll('div').transition('anim1').reverse();
  });

  querySelector('#btn-finish').onClick.listen((_) {
    select('#root').selectAll('div').transition('anim1').finish();
  });

  querySelector('#btn-pause').onClick.listen((_) {
    select('#root').selectAll('div').transition('anim1').pause();
  });

  querySelector('#btn-play').onClick.listen((_) {
    select('#root').selectAll('div').transition('anim1').play();
  });
}
```

# TODO

## Selection

- [ ] Bound data must be separate for each group
- [ ] insertBound in `BoundSelection`
- [ ] Lower
- [ ] Raise
- [ ] forEach
- [ ] filter
- [ ] size
- [ ] non-null size
- [ ] Events

## Transition

- [ ] active
- [ ] chain

## SVG

- [ ] svg
- [ ] Line
- [ ] Group