import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:waves/contants/comment_widget.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/contants/leave_comment.dart';
import 'package:waves/models/mywave_details_bussiness.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:waves/models/mywave_model.dart';
import 'package:waves/models/singlewave_model.dart';
import 'package:waves/contants/check_in_listing.dart';

class MyWaveDetailRegular extends StatefulWidget {
  final String waveId;
  final int age;
  final double lat;
  final double log;
  const MyWaveDetailRegular(this.waveId, this.age, this.lat, this.log,
      {Key? key})
      : super(key: key);

  @override
  _MyWaveDetailRegularState createState() => _MyWaveDetailRegularState();
}

class _MyWaveDetailRegularState extends State<MyWaveDetailRegular> {
  Completer<GoogleMapController> _mapController = Completer();

  late Future<SingleWaveModel> _future;
  Set<Marker> markers = Set();

  @override
  void initState() {
    _future = singleWavebyRegular();
    // TODO: implement initState

    super.initState();
  }

  Future<void> _pullRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _future = singleWavebyRegular();
    });
  }

  var customIcon;
  Future<SingleWaveModel> singleWavebyRegular() async {
    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(
                size: Size(150, 188), devicePixelRatio: 500.0),
            'assets/icons/pin.png')
        .then((d) {
      customIcon = d;
    });
    // Set<Marker> markers = Set();

    // image = bytes;
    var data;
    http.Response response = await http
        .post(Uri.parse(SingleWaveView), body: {'wave_id': widget.waveId});
    final jsonString = response.body;
    print(jsonString);
    final jsonMap = jsonDecode(jsonString);
    data = SingleWaveModel.fromJson(jsonMap);
    // var imgurl = SingleWaveModel.fromJson(jsonMap).wave.first.avatar;
    // print(imgurl);
    // String imgurl =
    //     "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAoHCBYWFRgVFRIYGBgYGhoYGBwaGBgYGhgcHhgaGhwYGB4cIS4lHB4rIRwaJjgmKy8xNTU1GiQ7QDs0Py40NTEBDAwMEA8QHxISHzQlJSw0NDFANDQ/PzUxMTs9MTQ0NTQ0ND81NDQ0NDQ3NjQ0NDQ0PTQ0NDExNjQ0NDQ0NDQ0NP/AABEIAOMA3gMBIgACEQEDEQH/xAAcAAEBAAIDAQEAAAAAAAAAAAAAAQYHAwUIAgT/xAA7EAABAgQDBgQEBAcBAAMBAAABAAIREiExAwRhIjJBUXGRBUKB8AYHodETFHKCI2KSorHB4VLC0vEz/8QAGQEBAAMBAQAAAAAAAAAAAAAAAAIDBAUB/8QAIBEBAAICAgMBAQEAAAAAAAAAAAECAxESMQQhUXEyIv/aAAwDAQACEQMRAD8A28901AjXy0N0e2WoujGzVN0BjZanooWzGIsqx01D1Uc4tMBZBXOmoOqNdKIG6ObLUdEa2ImN0BjZanooWTGIsqx01D1Uc4tMBZBXOmoOqNdAQN/uuLOYzMFjsR7w1rRtOcaALVnxP8fvxSWZaOGyxfbEf+n/AMD+7pZTpjtafSFrxXtn3i/xLlspEYuKC+FGM2n8xEDd6uICwfxT5l4jify+Axg4OxCXu/pbANPq5YETEkmpJiSakk3J5lRbKePWvftmtmtPXp3mb+Lc9ib2aeByZDDh/QAV17vFcwb5nGPXFxP/ALL8aK6K1jqFc2me5ftw/F8w2rc1jt6YuIP8OXaZT4zzzCD+YLwOD2teD1MJvqseReTSs9wRaY6lsnw75mxg3MZeHN2EYj1Y4xA6OPRZz4T4zgZhkcHFa/mBQtjaZpg5vqF59XLlsy7DcH4b3Mc2zmkgj1HDRU38es/z6W1zTHft6LYJb8VC2Jm4X7LX/wALfMBuIW4WcIa6zcUQaxx/nFmnUbPRbALoGUWt3WO1LVnUtNbRaNwrnTUHVGPlEDdHNlqOiMbMIm6ikMbLU9FC2YxFlWOmoeqhdKZRZBXOmoOqNdASm/3RzZajojWxExv9kBjZanojhGo6I0zUPVHGFB1QRjJanpRHMmqPqjSXUNuyOcWmAsgrnTUHWqNdKIG6PbCrb25o1oIiboI1stT0ohbMZhb7I0zUda/JVziDAWQHGag61XDmc2zBY5+I4Na0FznGwHvguZzZat6c1qP5i/EZx8T8ux38PDMHkWe8f/FtusTwCnjpN7aQvbjG3V/FfxK/NvgItwWnYZz/AJ383HsLDiTj6IulWsVjUMUzMzuRERevBERAREQEREBZ38CfGRwpctjujhHZw3k//wAiaBrj/wCNfL03cERRvSLxqUq2ms7h6Pa2Wp6UQtmMRZYL8tviM4zfymMYvw2xwybvwxASk8S2PqIciVnTnFpgLLm2rNbaltraLRuFcZqDrVGulEDdHthVt7c0a0ERN1FJGtlqelELYmYW+yNM1HdeSOJBlFkFcZqDrVGmFD1ojxLUfdGNmq6/ZALpqDrVA6Wh+iOaG1F+6NaDV1+yCNbLU9KIWTGYW1RhLqOt2RziDAW7oK4zUHWqNdKIG/3R4Dai/dGtBETdBj/xn4scplXvaQHv/h4cLhzgdr9rQ53UDmtHrNfmj4mX5luDHZwWVH8z4OMf2hncrClv8enGu/rHmtu34IiK9UJFCVs74I+DGsDMxmWTPMHMY4RDAahzwbv4wO71tC+SKRuU61m06hiPgvwdmsyA5uGGMNQ7EJYCObQAXHrCGqybB+WEKPzdeTMKg9S+vYLZThCo+6rWgiJusVvIvPXporhrHftrHOfK94EWZprjwD8Nza6ua4/4WIeMfD+Yy1cbCIaTAPbtMP7hY6GB0W+2majvsvjHww4FjmhzXCDmuAcCDcGNwva+RaO/ZbDWevTzmizT47+Dxlj+PgAnAcYObGJwnE0rxYTStjAcQsLW2l4vG4ZrVms6kREUkX6chnH4OIzFYdtjg4a82nQiIOhK394bnm4mEzEbEtxGhzehEYHUWPReeFtX5U54PwMTAca4T5m/ofEw/rDz+4LN5Fdxy+L8FtTpnTWy1PSiFkxiLI0l1HW7KucQYCyxNQ4zUHWqNdKJTf6VR4lqPujWgiJugjWy1PSipEajpVRhm3vsjiW0bbugNbLU9KI5k1R9UaSaOt2RziDBtu6CudNQdao10tCjgBVt+6NaCIuv2QRrZanpRCyYzBGxNHW7VUe4ttYeqDQXxDmvxc1j4n/rFfD9IcWt/tAXXIHRqeNe6LqxGo058zv2IiL14yj5f+DDMZoFwizBH4jgbF0YMafWv7CFugPhsm/3WAfKbBhgY+IN52KGH9LMNrh9XlZ+1oIib+4Ln57bvr42Ya6qgEtT0ohZMZuH2VaY732RziDAWVK0c6ag61QOgJeP3Rwhu/dGtBETf3CiDhzOVa5jmYgBa9pa4cwRAhaC8Y8POXx8TBJjI8tBNy27HHq0tPqvQTTHe+y1H80suG51rhZ+Cw+oc9v+A1afGtq2lGav+dsMREW1lFmHyxzBbnZY0xMN7Ycy2Dh9Gu7rD133wM8tz+XI/wDbh3w3j/ahkjdZ/E6Tq0N5OdNQdao10uyfcUcAKtv3RrQRE37LmNyNbLU9KIWzGYW+yNMaOt2Vc4gwFkBzpqDrVGmWh60Rwhu/dGtBq6/ZAc6ag6o18tCjgBVt+6NANXX7II1stT0Qtm2gq0k71uyhJBg23dBXOmoOqB0Nk+4o4Abt+9EaARE37dEHnHEwixzmG7CWnq0wP+F8rufi/K/h53MMhCLy8dHgPp/VD0XTLqVncRLnzGp0IiKTxtD5SZkDBx2cW4jXw0ewAH+wrP5I190WlPgTxhuWzTZzDDxB+G8mgbExY49HUjwDnFbrJIMBb3Gq5+eNX39bMM7rpXGag4VqgdLs+6o4Q3fpVGtBETft0oqVqNbLU9ELY7XuirSTvW7KOJBgLe41QVxmoOFarUPzQxgc41oO5hMaf1Fz3f4c1bXz2abg4bsRzg1jAXPN4ACPdaB8Vz7sxjYmO7ee4uhyFmt9GgD0Wnxq7ttTmt60/IiItrILIvgJk2fwP5S9x6DDf/uCx1Z18qMoHZnExDbDw5f3PcIfRju6ryzqkp0jd4bVa2Wp6IWzbXuiNJO9btVCSDBtu65rcrnTUHVA6XZ91RwA3b96I0AiJv26UQRrZanpRUtmqOijTHet2VcSKNt3QQMlqa8FSyaoojSTvW1oo4kHZtpVBS6agpxQOl2UcAN2+laI0AiLr60QQNlqa8ELZtr3RGEnetrSqEkGDbd+qDVnzXykMfCxwKPYWO/Ux0R6kP8A7Vga3P8AMfw4YmSe4CLsIjFHRsQ70lc4+i0wuhgtun4x5q6sIiK5ULZPwN8btDW5bNPhDZw8VxpDg3EJsRwdYi9anWyKGTHF41KVbTWdw9HtEtbx5IWTbXui0T4P8UZnLANw8WLBZjxOwdAatH6SFk+D80MUCDsrhn9L3MHYtd/lY7ePeOvbTGas9+m0C6agpxXFmM0zCaXYjw1rRFznEBoGpK1fmvmZjkfwsvh4Z5uc7E+mysU8W8Yx8w6bHxXPhUCgY39LWwAOsIr2vj2nv08tmrHXt3vxp8WHMn8LCiMBpjWIOK4Wc4cGi4aeprADEkRbKUisahntabTuRERSRFtz5XeHFuUdim+K9xH6W7AH9QefVakYwuIa0RcSA0cyTADuvQfhmU/AwcPBbVrGNbEC5AgT6mJ9Vm8m2oiPq/BXc7fsLpqCnFA6XZ91RwA3b6VojQCIuv2WJqQNlqa8ELZtr3RGEnetrSqOJBgLe4oKXTUFOKAy0NeKOEN2+lUaAd6+tEAumpbigfLS6OAG7fSqNAO9fWiCBstb8ELJtqyMJO9bWlUcTHZtpVBSZqW4oHS7PuqOgN2+laI0CG1fW+iDjxsASua4TNcC0jmCIEdl588RyZwcV+C67HuZ1ANHeogfVehmknetrSq1T80/DJMwzHaNnFbK4i07YCp1aW/0FaPGtq2vqjNXddsGREW5lEREBERAREQEREBERBkvy/8ADPx87hxGzhA4rqUi2Ab6zFp/aVusOlpdYN8rvDZMu/HhtYzoN5yMi0d3T/RZy0CG1fWi5+e3K342Ya6qgbLW/BC2ba90RhJ3ra0qhJjs20tqqVqkzUtxQOl2fdUdAbt9K0RoEK7310QQNlrfgks1bcEbE71taKuiN22lUAMlrfgkk1bI2Pmtqjox2baIE01LcUDpdm6Oh5b6ckbCG1fW6CBstb8Elm2vdEZHzW15o6Mdm2ltUFJmpbisd+O/DPxsniNAi/D/AIrOrYkgalhcPVZE6HlvpyQQhtQjqpVnUxMPLRuNPN6Ltvifwv8ALZnEwoQaHTM/Q6rYdN3q0rqV04mJjcMExqdCIi9eCIiAiIgIiIC5srlnYj2YbRF73NY3q4gCOlVwrNflh4X+JmHY7hs4DdnV7wWthzg2f1LVC9uNZlKteUxDaeRyTcDDZht3cNjcNvQACJ1p9VzyTbVlWx81tVHRjs20XMb1Jmpbik0uzf8A6joeW+nJGwhtX1uggbLW/BJZtr3RGR81teaGMabultUFJmpbigdLS/FHQ8t9EbDzX1QJpqW4qzy0uo+HlvojIea+qCSy1vw5JJNtWRkfNbXmhjHZtpZBZpqW480ml2b/APUdDy305I2ENq+t9EEllrfhySSbasjI+a2vNDGOzbSyDX/zV8OmZh5lrasP4b/0uOyT0fT961gvQ3i2Rbj4OJgmz2lphcRFHDUGB9F5+zOXdhufhuEHMc5jh/M0wPpRbfHvuOPxkzV1O/riREWlSIiICIiAiIgErd3wN4P+XyeHNR7/AOK8QrF0CGnUNDR6Far+EfChmM3h4bhsgz4nKVkCQdCZW/uW9TGNN36Q4rJ5N+qtOCvdlmmpbjzSeXZuj4eW+iMhDavrdZGhJZa34cklm2rf8RkfNbXmhjHZtpZBZpqW480ml2fr1R0PLfTkjYQrva30QSWWt+HJJZq24c0ZHzW1VdHy20QJZa34ckkmrb6o2Pmtqjox2baIJNNS3Hmk8uzdV0PLfTkjYQ2r63QSEtb8OXuyss1badFGR81teaOjHZtpbVAmmpbjzVnl2bo6HlvpyRsIbV9boJCWt+HL3Zao+aHhUmO3MNEG44g7R7QB/c2H9LltdkfNbXmul+MPCTmctiYbRFwE+H+ttQB1q39xVmK3G0ShkryrpopECLpMIiIgIiICIv1eGZF2PjMwW7z3Bsf/ACPM7o1sXei8mdPWzPlb4RLgOx3CDsUwb+hpIHd0x1Aas6mhs+keq4cvl24bGMwhBrGhgA4NAgP8LmEIV3vrHguZe3K0y3UrxrEJLLW/DkrJNtWRsfNbVR0Y7NtFFImmpbjzSeXZvr1VdDy305I2ENq+t0EllrfhyVlmrbTooyPmtrzQxjTd0tqgTTUtx5pNLS/Hkq6HlvojYea+qBNNS3FJ5aXR8PLfRGQ819UCWWt+CSTbVlGR81teaOjHZtogTTUtx5pNLs3/AOquh5b6UojYQ2r630QJZa34ckkm2rKMj5ra1qjox2baIE01Lceas0uz9eqOh5b6UojYQ2r630QaU+PfB/y+bfKNjF/iM5RJ2m+jono5qxpbj+YfhBx8q58DPgRe3mWw22/07XVgWnF0MN+VWPJXjYREVyoREQFsP5VeFxe/Mubb+Fh9TAvcOglEdXLX+DhOe5rGCLnuDWjm5xAaPUkLf3gfhzctl8PAEIsbAmG841c71cSfVZ/IvxjX1dhrud/H74S1vH0SWO16w6KM/m9I1QxjTd+kOKwtZNNS3FJ5dm6r4eW+iNhDavqgSy1vw5JLNtW/4oyPmtrzQxjs20sgTTUtx5pNLs/Xqq6HlvpSiNhCu99dECWWt+HJJZq24KMj5ra1VdHy20QC2Wt+CBk1bI0Eb1taqOBJ2baUQA6aluKTy7N1XEHdvpSiNIhtX1qgES1vwSWba90UYCN62taoQY7NtKDVADpqW4pPLs3VdA7t9KURpENq+tSgES1vwQNm2vdFGAjetrWqEGOzbSg1QIzUI/3HhBaG+KPCfyuZxMHygz4erHVb2q3q0rfToHdvpSiwb5neEz5duYaNvBO1zOG41jzlMp0BcrsF+NtfVWau67+NUIiLoMYiKw5CPS50CDNPln4T+JmDjubFmBu8jiOBA/pbE9S1bbljtesOn/4ul+EvB/yuWZhuAmInxOMXuq7sINjyaF3JBjEbv01oubltyttux1410AzUtBJobPpHqq6u76wogIhA731jwqq0yWWt+CBs21ZGgjetrVRwMdm2lEAOmpbik0uz7qq6B3b6UojSIbV9alAIlrfgks217oowEb1ta1RwMabv01QA6aluKTS0vxVdA7t9KI0gb19aoAfNS3FC+Wl0cQd2+lEYQKOvrVAllrfggbNtWUYCN62taoQSYtt2QA6aluKF0uz7qq4g7t9KUQEAQdfv0QCJa34IGzbSjARvW1rVCCTFtuyAHTUtxQul2fdVXEHdvpSiAgCDr9+iARLW/BceNl24jXB4i17S1zeBBECD1C5GgjetrVQgkxG77jRB5+8a8Odlsd+C6Ow6DSfM01Y71aR6xX4Vs/5qeEBzGZpgqyDMSA8jjsuPRxh+/RawXSxX51iWHJXjbQsr+Xfg/wCYzQe4RZgQxHci+Ow3uC79mqxQlbt+B/BTlsqwEQfifxMTQuAgw/paAOseajnvxr+pYq7syIGaloVSaGz6d1XGO79KICIQO99dKrntgRLW8UljtesOiNpvekaqEGMRu/SHGiAHTUtxQvl2bquIO7fSiNIAg6+tUAiWt+CBs217oowEb1ta1QgkxbbsgB01LcULpdn3VVxB3b6UojSAIG/uFUAiWt+CATVtwRoI3ra1R0Tu20ogFstRXggZNUqNBFXW7o4EmLbdkBrpqGnFC+XZVcQd2/ZGkAQdfugFstRXggbNte6KNBG9bvVCCTFtuyAHTUNOKF8uyq4g7t+yNIAg6/dALZaivBA2ba90UaCN63eqEEmIt2QA6ahpxQuhs+6quIO7fsjSAIG/uFUHBnsmx+G/DeJmPaWOGhEDDVaA8SyL8DFfgv3mOLSeYuHDQgg+q9CtEN77rXPzV8G3M40UEMPE6eR59Yt9WrR499W19UZqbjfxjPwL4L+ZzTA4Rw8P+I/kYHZb6uhTkHLdhdDZ91WL/APg35fKtJEMXFIxH8CARsN9G1hzLllLSAIG/uFVDNfnb8TxV41CJaisaIGx2vXsjRDe+6hBJiN33GiqWAM1DSCTQ2fTuq4x3fXggIhA73++FUAtlqK8EDZtpRoIq63dCCTFtuyAHTUNOKF0uz7qq4g7t+1EaQBB1+6AWy1FeCBs217ojQRvW7qEEmIt260QA6ahpxVjLQV4o4x3b9ka4Cjr90H1j29UwN1EQceXv6Jjb3ZEQfeYt6/dXB3e6Ig+Mvf0Uxt7siIPvMW9furhbvdEQfGXv6KYm/2REH3mLDquLFyzMXCOHiNDmOBDmmoNeKIg+svc9ExN7siIPvMWHVVm76H/AGiIPnL3K+X7/qP9IiDkx7eqYG73REHHl7+n2TG3uyIg+8xb1Vwt3uiIOPL3PRMe/oqiD//Z";
    // Uint8List bytes = (await NetworkAssetBundle(Uri.parse(imgurl)).load(imgurl))
    //     .buffer
    //     .asUint8List();
    markers.add(Marker(
        //add start location marker
        markerId: MarkerId(widget.lat.toString()),
        position: LatLng(widget.lat, widget.log), //position of marker
        infoWindow: InfoWindow(
            //popup info
            // title: 'Car Point ',
            // snippet: 'Car Marker',
            ),
        // icon: BitmapDescriptor.fromBytes(bytes),
        icon: customIcon
        //Icon for Marker
        ));
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0), // here the desired height
          child: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            leading: Padding(
              padding: const EdgeInsets.only(top: 17.0, left: 5),
              child: IconButton(
                iconSize: 24,
                alignment: Alignment.bottomLeft,
                icon: const FaIcon(FontAwesomeIcons.arrowLeft),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            flexibleSpace: Container(
                width: 85,
                height: 70,
                margin: const EdgeInsets.only(top: 40),
                child: Image.asset(
                  'assets/login.png',
                  width: 85,
                  height: 70,
                  fit: BoxFit.contain,
                )),
            centerTitle: true,
          )),
      body: FutureBuilder<SingleWaveModel>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data!.wave.first;
              var date = DateFormat('yyyy-MM-dd').format(data.date);
              var time = DateTime.now().difference(data.createdAt).inMinutes;
              String tt = time > 59
                  ? time > 1440
                      ? '${DateTime.now().difference(data.createdAt).inDays.toString()} d'
                      : '${DateTime.now().difference(data.createdAt).inHours.toString()} h'
                  : "${DateTime.now().difference(data.createdAt).inMinutes.toString()} m";
              return RefreshIndicator(
                onRefresh: _pullRefresh,
                child: ListView(
                  // physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Container(
                        height: 251,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(188, 220, 243, 1),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(60),
                              bottomRight: Radius.circular(60)),
                        ),
                        child: Column(children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  // width: 102,
                                  // color: Colors.black,
                                  margin: const EdgeInsets.only(
                                      right: 20, left: 20),
                                  child: Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Colors.black,
                                          child: CircleAvatar(
                                            radius: 48,
                                            backgroundImage: NetworkImage(
                                                data.media.first.location),
                                          )),
                                      CircleAvatar(
                                          radius: 19,
                                          backgroundColor:
                                              widget.age > 17 && widget.age < 30
                                                  ? const Color.fromRGBO(
                                                      0, 0, 255, 1)
                                                  : widget.age > 29 &&
                                                          widget.age < 50
                                                      ? const Color.fromRGBO(
                                                          255, 255, 0, 1)
                                                      : const Color.fromRGBO(
                                                          0, 255, 128, 1),
                                          child: CircleAvatar(
                                            radius: 17,
                                            backgroundImage:
                                                NetworkImage(data.avatar),
                                          ))
                                    ],
                                  ),
                                ),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(
                                            data.username,
                                            style: GoogleFonts.quicksand(
                                                fontSize: 19,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(width: 15),
                                          if (AccountType != 'BUSINESS')
                                            FaIcon(
                                              FontAwesomeIcons.solidIdBadge,
                                              color: data.userInfo.age > 17 &&
                                                      data.userInfo.age < 30
                                                  ? const Color.fromRGBO(
                                                      0, 0, 255, 1)
                                                  : data.userInfo.age > 29 &&
                                                          data.userInfo.age < 50
                                                      ? const Color.fromRGBO(
                                                          255, 255, 0, 1)
                                                      : const Color.fromRGBO(
                                                          0, 255, 128, 1),
                                            ),
                                          const SizedBox(width: 30),
                                          Text(
                                            tt,
                                            style: GoogleFonts.quicksand(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        width: 200,
                                        child: Text(
                                          data.wavesLocation,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          style: GoogleFonts.quicksand(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      Text(
                                        '${data.eventInfo.eventName}   $date  ${data.startTime} - ${data.endTime}',
                                        style: GoogleFonts.quicksand(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      )
                                    ])
                              ]),
                          Container(
                              height: 130,
                              width: MediaQuery.of(context).size.width - 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50)),
                              child: GoogleMap(
                                myLocationEnabled: false,
                                // onTap: _mapTapped,
                                initialCameraPosition: CameraPosition(
                                  target:
                                      LatLng(data.lattitude, data.longitude),
                                  zoom: 17,
                                ),
                                onMapCreated:
                                    (GoogleMapController mapController) {
                                  _mapController.complete(mapController);
                                },
                                zoomControlsEnabled: false,
                                markers: markers,
                              ))
                        ])),
                    const SizedBox(height: 5),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'COMMENTS',
                            style: GoogleFonts.quicksand(
                                fontSize: 19, fontWeight: FontWeight.w300),
                          ),
                          TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (_) =>
                                        CheckInListing(widget.waveId));
                              },
                              child: Text(
                                'Check-In List',
                                style: GoogleFonts.quicksand(
                                    fontSize: 13,
                                    color:
                                        const Color.fromRGBO(42, 124, 202, 1),
                                    fontWeight: FontWeight.w300),
                              ))
                        ]),
                    const SizedBox(height: 5),
                    CommentScreen(data.waveComments, data.id, data.userId),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
