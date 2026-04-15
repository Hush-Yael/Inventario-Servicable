import 'package:flutter_query/flutter_query.dart';
import 'package:servicable_stock/auth/auth_constants.dart';
import 'package:servicable_stock/core/db/db.dart';

typedef UsersList = List<User>;

typedef UsersQuery = QueryResult<List<User>, dynamic>;

typedef DeleteMutation = MutationResult<dynamic, Object?, Object?, List<int>>;

typedef ChangeRoleMutation =
    MutationResult<dynamic, Object?, UserRole, List<({int id, String role})>>;
