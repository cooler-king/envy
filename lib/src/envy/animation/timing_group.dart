import '../envy_node.dart';
import 'timed_item_group.dart';

/// TimingGroup is the base class for specialzed timing groups.
///
abstract class TimingGroup extends TimedItemGroup {}

/// A sequence timing group is a type of timing group that schedules
/// its child timed items such that they play in turn following their
/// order in the group. This ordering is achieved by adjusting the
/// start time of each child timed item in the group.
///
class SequenceTimingGroup extends TimingGroup {
  @override
  bool attach(EnvyNode node, [int index]) {
    final bool tf = super.attach(node, index);
    calcStartTimes();
    return tf;
  }

  @override
  bool detach(EnvyNode node) {
    final bool tf = super.detach(node);
    calcStartTimes();
    return tf;
  }

  /// Calculate the start times of the group children.
  ///
  void calcStartTimes() {
    num prevEnd = 0;
    for (EnvyNode child in children) {
      if (child is TimedItemGroup) {
        child.startTime = prevEnd;
        prevEnd = child.endTime;
      }
    }
  }

  /// The intrinsic iteration duration of a sequence timing group is
  /// equivalent to the start time of a hypothetical child timed item
  /// appended to the group's children calculated according to the
  /// definition in section 3.13.4.1 The start time of children of a
  /// sequence timing group unless that produces a negative value, in
  /// which case the intrinsic iteration duration is zero.
  ///
  /// As a result, if the sequence timing group has no child timed
  /// items the intrinsic iteration duration will be zero.
  ///
  @override
  num get intrinsicIterationDuration {
    if (children.isEmpty) return 0;

    // Can't assume all children are Timed Items; scroll backwards to find last one
    for (int i = children.length - 1; i > -1; i--) {
      if (children[i] is TimedItemGroup) {
        return (children[i] as TimedItemGroup).endTime;
      }
    }

    return 0;
  }
}

/// A parallel timing group is a type of timing group that
/// schedules its child timed items such that they play simultaneously.
///
class ParallelTimingGroup extends TimingGroup {
  @override
  num get intrinsicIterationDuration {
    if (children.isEmpty) return 0;

    num maxEndTime = 0;
    num endTime;
    for (dynamic child in children) {
      if (child is TimedItemGroup) {
        endTime = child.endTime;
        if (endTime > maxEndTime) maxEndTime = endTime;
      }
    }

    return maxEndTime;
  }
}
