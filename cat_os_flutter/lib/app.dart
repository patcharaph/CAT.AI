import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "services/memory_storage.dart";
import "state/cat_controller.dart";
import "ui/cat_screen.dart";

class CatOsApp extends StatelessWidget {
  const CatOsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CatController>(
      create: (_) => CatController(storage: MemoryStorage()),
      child: MaterialApp(
        title: "CAT.AI",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const CatScreen(),
      ),
    );
  }
}
