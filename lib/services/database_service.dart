import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Query<Map<String, dynamic>>> find(
    String collection, {
    int? limit,
    DocumentSnapshot<Object?>? lastDocument,
  }) async {
    try {
      Query<Map<String, dynamic>> queryCollection =
          _firestore.collection(collection);

      if (limit != null) {
        queryCollection = queryCollection.limit(limit);
      }

      if (lastDocument != null) {
        queryCollection = queryCollection.startAfterDocument(lastDocument);
      }

      return queryCollection;
    } catch (e) {
      // // log('Error in find: $e');
      throw Exception('Error fetching data from $collection: $e');
    }
  }

  Future<QueryDocumentSnapshot<Map<String, dynamic>>?> findOne(
    String collection, {
    required Object field,
    required Object isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    Iterable<Object?>? arrayContainsAny,
    Iterable<Object?>? whereIn,
    Iterable<Object?>? whereNotIn,
    bool? isNull,
  }) async {
    try {
      final queryCollection = await find(
        collection,
        limit: 1,
      );

      final querySnapshot = await queryCollection
          .where(
            field,
            isEqualTo: isEqualTo,
            arrayContains: arrayContains,
            arrayContainsAny: arrayContainsAny,
            whereIn: whereIn,
            whereNotIn: whereNotIn,
            isNull: isNull,
            isGreaterThan: isGreaterThan,
            isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
            isLessThan: isLessThan,
            isLessThanOrEqualTo: isLessThanOrEqualTo,
          )
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first;
      }

      return null;
    } catch (e) {
      // // log('Error in findOne: $e');
      throw Exception('Error fetching single document from $collection: $e');
    }
  }

  Future<QueryDocumentSnapshot<Map<String, dynamic>>?> findOneAndUpdate(
    String collection, {
    required Object field,
    required Object isEqualTo,
    required Map<String, dynamic> data,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    Iterable<Object?>? arrayContainsAny,
    Iterable<Object?>? whereIn,
    Iterable<Object?>? whereNotIn,
    bool? isNull,
  }) async {
    try {
      final querySnapshot = await findOne(
        collection,
        field: field,
        isEqualTo: isEqualTo,
        isNotEqualTo: isNotEqualTo,
        isLessThan: isLessThan,
        isLessThanOrEqualTo: isLessThanOrEqualTo,
        isGreaterThan: isGreaterThan,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        arrayContains: arrayContains,
        arrayContainsAny: arrayContainsAny,
        whereIn: whereIn,
        whereNotIn: whereNotIn,
        isNull: isNull,
      );

      if (querySnapshot != null && querySnapshot.exists) {
        await querySnapshot.reference.update(data);
        return querySnapshot;
      }

      return null;
    } catch (e) {
      // // log('Error in findOneAndUpdate: $e');
      throw Exception('Error updating document in $collection: $e');
    }
  }

  Future<QueryDocumentSnapshot<Map<String, dynamic>>?> findOneAndDelete(
    String collection, {
    required Object field,
    required Object isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    Iterable<Object?>? arrayContainsAny,
    Iterable<Object?>? whereIn,
    Iterable<Object?>? whereNotIn,
    bool? isNull,
  }) async {
    try {
      final querySnapshot = await findOne(
        collection,
        field: field,
        isEqualTo: isEqualTo,
        isNotEqualTo: isNotEqualTo,
        isLessThan: isLessThan,
        isLessThanOrEqualTo: isLessThanOrEqualTo,
        isGreaterThan: isGreaterThan,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        arrayContains: arrayContains,
        arrayContainsAny: arrayContainsAny,
        whereIn: whereIn,
        whereNotIn: whereNotIn,
        isNull: isNull,
      );

      if (querySnapshot != null && querySnapshot.exists) {
        await querySnapshot.reference.delete();
        return querySnapshot;
      }

      return null;
    } catch (e) {
      // // log('Error in findOneAndDelete: $e');
      throw Exception('Error deleting document in $collection: $e');
    }
  }

  CollectionReference<Map<String, dynamic>> getCollection(String collection) {
    return _firestore.collection(collection);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(
    String collection,
    String documentId,
  ) async {
    try {
      return await _firestore.collection(collection).doc(documentId).get();
    } catch (e) {
      // log('Error in getDocument: $e');
      throw Exception(
          'Error fetching document $documentId from $collection: $e');
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getDocumentStream(
    String collection,
    String documentId, {
    int? limit,
  }) {
    try {
      if (limit != null) {
        return _firestore
            .collection(collection)
            .doc(documentId)
            .snapshots()
            .take(limit);
      } else {
        return _firestore.collection(collection).doc(documentId).snapshots();
      }
    } catch (e) {
      // log('Error in getDocumentStream: $e');
      throw Exception(
          'Error streaming document $documentId from $collection: $e');
    }
  }

  Future<bool> hasCollection(String collection) async {
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection(collection).limit(1).get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      // log('Error checking collection: $e');
      return false;
    }
  }

  Future<DocumentReference<Map<String, dynamic>>> addData(
    String collection,
    Map<String, dynamic> data,
  ) async {
    try {
      return await _firestore.collection(collection).add(data);
    } catch (e) {
      // log('Error in addData: $e');
      throw Exception('Error adding data to $collection: $e');
    }
  }
}
