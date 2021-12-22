
part of "bird_post_cubit.dart";

enum BirdPostStatus {initial, error, loading, loaded, postAdded, postRemoved}

class BirdPostState extends Equatable {

  final List<BirdModel> birdPosts;

  final BirdPostStatus status;

  const BirdPostState ({required this.birdPosts, required this.status});

  @override
  // TODO: implement props
  List<Object?> get props => [birdPosts, status];

  BirdPostState copyWith({
    List<BirdModel>? birdPosts,//добавили "?" - типа опционально (необязательно тут указывать все параметры указывать)
    BirdPostStatus? status,
}) {
    return BirdPostState(
      birdPosts: birdPosts ?? this.birdPosts, // "this" относится к текущему стейту
      status: status ?? this.status,
      //вобщем: либо мы возвращаем полученные birdPosts и status, и если они null, то возвращаем birdPosts и status текущего стейта
    );
  }

}