import 'package:flutter_query/flutter_query.dart';
import 'package:servicable_stock/core/db/db.dart';

typedef UpdateDataMutation =
    MutationResult<User, Object?, UpdateDataInput, Object?>;

typedef UpdateDataInput = ({String name, String username});

typedef UpdatePassMutation =
    MutationResult<User, Object?, UpdatePassInput, Object?>;

typedef UpdatePassInput = String;
