import 'package:flutter/material.dart';


void main()=> runApp(ScrollableColumn());
class ScrollableColumn extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, //Removing Debug Banner
        home: Scaffold(
          appBar: AppBar(
            title: const Text('My App'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width:double.infinity,
                  //height: MediaQuery.of(context).size.height,
                  color:Colors.red,
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    'Some text here',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Item $index'),
                      subtitle: const Text('Subtitle'),
                      leading: const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: (){},
                    );
                  },
                  itemCount: 20,
                ),
              ],
            ),
          ),
        )
    );
  }
}
