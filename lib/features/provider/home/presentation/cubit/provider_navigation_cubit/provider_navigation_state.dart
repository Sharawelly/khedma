part of 'provider_navigation_cubit.dart';

class ProviderNavigationState extends Equatable {
  const ProviderNavigationState({this.current = ProviderNavItem.home});

  final ProviderNavItem current;

  ProviderNavigationState copyWith({ProviderNavItem? current}) {
    return ProviderNavigationState(
      current: current ?? this.current,
    );
  }

  @override
  List<Object> get props => <Object>[current];
}
