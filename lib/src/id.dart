typedef id = String Function() Function();

final id idCount = () {
  int id = 0;
  return () => (++id).toString();
};

final nextUnitID = idCount();