class GenerateUid {
  String newUid(String myUid, String friendUid) {
    String uid = '';
    if (myUid.compareTo(friendUid) == 0) {
      uid = myUid + friendUid;
    } else if (myUid.compareTo(friendUid) == 1) {
      uid = myUid + friendUid;
    } else if (myUid.compareTo(friendUid) == -1) {
      uid = friendUid + myUid;
    }
    return uid;
  }
}
