import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> characters = [];
  List<dynamic> names = [];
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : names.isEmpty
              ? Center(
                  child: ElevatedButton(
                    onPressed: () {
                      fetchData2();
                    },
                    child: const Text("Fetch Data"),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: names.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          // leading: Image(
                          //   image: NetworkImage(
                          //     characters[index]['image'],
                          //   ),
                          // ),
                          title: Text(names[index]['username']),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  void fetchData2() async {
    setState(() {
      _loading = true;
    });
    HttpLink link = HttpLink("http://localhost:4000/graphql");
    GraphQLClient qlClient = GraphQLClient(
      link: link,
      cache: GraphQLCache(
        store: HiveStore(),
      ),
    );

    QueryResult queryResult = await qlClient.query(
      QueryOptions(
        document: gql("""
query getUsers() {
  users {
    username
    }
}
"""),
      ),
    );
    setState(() {
      names = queryResult.data!['users'];
      _loading = false;
    });
  }

  void fetchData() async {
    setState(() {
      _loading = true;
    });
    HttpLink link = HttpLink("https://rickandmortyapi.com/graphql");
    GraphQLClient qlClient = GraphQLClient(
      link: link,
      cache: GraphQLCache(
        store: HiveStore(),
      ),
    );

    QueryResult queryResult = await qlClient.query(
      QueryOptions(
        document: gql("""
query {
  characters() {
    results {
      name
      image
    }
  }
}
"""),
      ),
    );
    setState(() {
      characters = queryResult.data!['characters']['results'];
      _loading = false;
    });
  }
}
