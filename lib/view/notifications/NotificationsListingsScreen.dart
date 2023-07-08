import 'package:flutter/material.dart';
import '../../view/notifications/NotificationViewScreen.dart';
import 'SampleDataForNow.dart';

class NotificationsListingsScreen extends StatefulWidget {
  const NotificationsListingsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsListingsScreen> createState() =>
      _NotificationsListingsScreenState();
}

class _NotificationsListingsScreenState
    extends State<NotificationsListingsScreen> {
  final List<Color> colors = [
    Colors.pink.shade300,
    Colors.indigo.shade300,
  ];

  List<SampleDataForNow> _list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SampleDataForNow data = SampleDataForNow();
    data.header = 'Train Crash';
    data.body =
        "<h2>About Me</h2><p>Hello! My name is John and I'm a passionate software engineer. I have been coding for over 10 years and love every minute of it. My expertise lies in web development, particularly in front-end technologies like HTML, CSS, and JavaScript. I have worked on numerous projects, ranging from small personal websites to large-scale e-commerce platforms.</p><p>In addition to web development, I also have experience in mobile app development using frameworks like React Native. I enjoy creating user-friendly interfaces and optimizing performance to deliver exceptional user experiences.</p><p>When I'm not coding, you can find me exploring the outdoors, playing guitar, or reading up on the latest tech trends. I believe in continuous learning and staying up-to-date with the ever-evolving world of technology.</p><h2>About Me</h2><p>Hello! My name is John and I'm a passionate software engineer. I have been coding for over 10 years and love every minute of it. My expertise lies in web development, particularly in front-end technologies like HTML, CSS, and JavaScript. I have worked on numerous projects, ranging from small personal websites to large-scale e-commerce platforms.</p><p>In addition to web development, I also have experience in mobile app development using frameworks like React Native. I enjoy creating user-friendly interfaces and optimizing performance to deliver exceptional user experiences.</p><p>When I'm not coding, you can find me exploring the outdoors, playing guitar, or reading up on the latest tech trends. I believe in continuous learning and staying up-to-date with the ever-evolving world of technology.</p><h2>About Me</h2><p>Hello! My name is John and I'm a passionate software engineer. I have been coding for over 10 years and love every minute of it. My expertise lies in web development, particularly in front-end technologies like HTML, CSS, and JavaScript. I have worked on numerous projects, ranging from small personal websites to large-scale e-commerce platforms.</p><p>In addition to web development, I also have experience in mobile app development using frameworks like React Native. I enjoy creating user-friendly interfaces and optimizing performance to deliver exceptional user experiences.</p><p>When I'm not coding, you can find me exploring the outdoors, playing guitar, or reading up on the latest tech trends. I believe in continuous learning and staying up-to-date with the ever-evolving world of technology.</p><h2>About Me</h2><p>Hello! My name is John and I'm a passionate software engineer. I have been coding for over 10 years and love every minute of it. My expertise lies in web development, particularly in front-end technologies like HTML, CSS, and JavaScript. I have worked on numerous projects, ranging from small personal websites to large-scale e-commerce platforms.</p><p>In addition to web development, I also have experience in mobile app development using frameworks like React Native. I enjoy creating user-friendly interfaces and optimizing performance to deliver exceptional user experiences.</p><p>When I'm not coding, you can find me exploring the outdoors, playing guitar, or reading up on the latest tech trends. I believe in continuous learning and staying up-to-date with the ever-evolving world of technology.</p>";
    data.date = '3rd June 2023';
    data.time = '4:30 pm';
    _list.add(data);

    SampleDataForNow data1 = SampleDataForNow();
    data1.header = 'Plane Crash';
    data1.body = """
    <!DOCTYPE html>
    <html>
      <head>
        <style>
        table, th, td {
          border: 1px solid black;
          border-collapse: collapse;
        }
        th, td, p {
          padding: 5px;
          text-align: left;
        }
        </style>
      </head>
      <body>
        <h2>A sample plugin to test this dependency</h2>
        
        <table style="width:100%">
          <caption>Sample HTML Table</caption>
          <tr>
            <th>Month</th>
            <th>Savings</th>
          </tr>
          <tr>
            <td>January</td>
            <td>100</td>
          </tr>
          <tr>
            <td>February</td>
            <td>50</td>
          </tr>
        </table>
        
        <p>Image loaded from web</p>
        <img src="https://i.imgur.com/wxaJsXF.png" alt="web-img">
      </body>
    </html>
    """;
    data1.date = '4th June 2023';
    data1.time = '4:30 pm';
    _list.add(data1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                ListView.separated(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _list.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: Card(
                          color: Colors.grey.shade100,
                          //colors[index % colors.length],
                          elevation: 4.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                color: colors[index % colors.length],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    _list[index].header.toString(),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  _list[index].body.toString(),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.grey,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _list[index].date.toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      _list[index].time.toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationViewScreen(
                                      data: _list[index],
                                    )),
                          );
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
