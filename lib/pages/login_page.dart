import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:app5/database/sqlite_helper.dart';
import 'package:app5/models/sqlite_user_model.dart';
import 'package:app5/providers/auth_provider.dart';
import 'package:app5/providers/user_info_provider.dart';
import 'package:app5/widgets/version_app.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  List<String> backgroundList = [
    'assets/login_background.jpg',
    'assets/demo_background.jpg',
  ];
  //text controller form
  TextEditingController hp = TextEditingController();
  TextEditingController password = TextEditingController();
  //initialize carousel controller
  final CarouselSliderController _controller = CarouselSliderController();
  int _current = 0;
  //isloading
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //initialize providers
    AuthProvider auth = Provider.of<AuthProvider>(context);
    UserInfoProvider info = Provider.of<UserInfoProvider>(context);
    //initialize width dan height
    final double height = MediaQuery.of(context).size.height * 0.5;
    final double widht = MediaQuery.of(context).size.width;

    redirect() => Navigator.pushReplacementNamed(context, '/main');
    loginFailed() => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Gagal login',
              textAlign: TextAlign.center,
            ),
          ),
        );
    //login controller
    loginController() async {
      setState(() {
        isLoading = true;
      });
      if (await auth.login(
        hp: hp.text,
        password: password.text,
        action: 'login',
      )) {
        //get usersinfo
        await info.getUserInfo(token: auth.user.token!);
        SqLiteHelper dbHelper = SqLiteHelper();
        //initialize to sqliteusermodel
        var userdata = SqliteUserModel(
          username: info.userInfo.username,
          active: info.userInfo.active,
          activekey: info.userInfo.activekey,
          cpos: info.userInfo.cpos,
          email: auth.user.emailUser,
          iduser: info.userInfo.iduser,
          ip: info.userInfo.ip,
          joinsisko: info.userInfo.join,
          kelamin: info.userInfo.kelamin,
          lastlogin: info.userInfo.lastlogin,
          nama: info.userInfo.nama,
          nomor: auth.user.nomor,
          nomorsc: info.userInfo.nomorsc,
          password: info.userInfo.password,
          photo: info.userInfo.photo,
          photopp: info.userInfo.photopp,
          photothumb: info.userInfo.photothumb,
          position: info.userInfo.position,
          siskoid: info.userInfo.siskoid,
          siskokode: info.userInfo.siskokode,
          siskoHakAkses: auth.user.siskohakakses,
          siskonpsn: info.userInfo.siskonpsn,
          siskostatuslogin: info.userInfo.siskostatuslogin,
          uploadphoto: info.userInfo.uploadphoto.toString(),
          photodefault: info.userInfo.photoPP?.photodefault,
          photodefaultthumb: info.userInfo.photoPP?.photodefaultthumb,
          verified: info.userInfo.verified,
          token: auth.user.token,
          tokenss: auth.user.tokenss!,
          tokenpp: auth.user.tokenpp,
          islogin: 1,
          hp: auth.user.hp,
          tanggallahir: auth.user.tglLahir,
          namalengkap: auth.user.siskonamalengkap,
        );
        //insert to sqlite
        dbHelper.insertUser(userdata);
        redirect();
      } else {
        loginFailed();
      }
      setState(() {
        isLoading = false;
      });
    }

    //group button singup dan view demo
    Widget groupButtonSlideoOne() {
      return Positioned(
        top: 200,
        left: 20,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.circular(8)),
                      backgroundColor: const Color.fromARGB(255, 243, 163, 43),
                    ),
                    child: const Row(
                      children: <Widget>[
                        Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Icon(
                          Icons.person_add_alt_sharp,
                          color: Colors.white,
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 18,
                ),
                TextButton(
                    onPressed: () => _controller.nextPage(),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.circular(8)),
                      backgroundColor: const Color.fromARGB(255, 128, 128, 128),
                    ),
                    child: const Row(
                      children: <Widget>[
                        Text(
                          'View Demo',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        )
                      ],
                    )),
              ],
            ),
          ],
        ),
      );
    }

    //group button guru, siswa, dan orang tua
    Widget groupButtonSlideTwo() {
      return Positioned(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    hp.text = '0811223344';
                    password.text = 'sayaguru';
                  });
                  loginController();
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(8)),
                  backgroundColor: Colors.blue,
                ),
                child: const SizedBox(
                  width: 80,
                  height: 25,
                  child: Center(
                    child: Text(
                      'Guru',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    hp.text = '0811224455';
                    password.text = 'siswademo';
                  });
                  loginController();
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(8)),
                  backgroundColor: Colors.orange,
                ),
                child: const SizedBox(
                  width: 80,
                  height: 25,
                  child: Center(
                    child: Text(
                      'Siswa',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    hp.text = '0811225566';
                    password.text = 'ortudemo';
                  });
                  loginController();
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(8)),
                  backgroundColor: Colors.green,
                ),
                child: const SizedBox(
                  width: 80,
                  height: 25,
                  child: Center(
                    child: Text(
                      'Orang Tua',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    //login button
    Widget loginButton() {
      return SizedBox(
        height: 50,
        width: double.infinity,
        child: TextButton(
          onPressed: loginController,
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(8)),
            backgroundColor: const Color.fromARGB(255, 73, 72, 72),
          ),
          child: const Text(
            'Login',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    //loading button
    Widget loadingButton() {
      return SizedBox(
        height: 50,
        width: double.infinity,
        child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(8)),
              backgroundColor: const Color.fromARGB(255, 73, 72, 72),
            ),
            child: const CircularProgressIndicator.adaptive(
              backgroundColor: Colors.white,
            )),
      );
    }

    //slideshow assets
    List<Widget> backgroundSlider = backgroundList
        .map(
          (item) => Stack(
            children: <Widget>[
              Image.asset(
                item,
                fit: BoxFit.cover,
                height: height,
                width: widht,
              ),
              _current == 0 ? groupButtonSlideoOne() : groupButtonSlideTwo()
            ],
          ),
        )
        .toList();
    //slider
    Widget slider() {
      return Stack(
        children: [
          CarouselSlider(
            items: backgroundSlider,
            options: CarouselOptions(
              viewportFraction: 1,
              enableInfiniteScroll: false,
              height: height,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
            carouselController: _controller,
          ),
          Positioned(
            top: 400,
            left: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: backgroundList.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.blue.shade500)
                            .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      );
    }

    //login form
    Widget loginForm() {
      return Center(
        child: Card(
          color: Theme.of(context).colorScheme.onPrimary,
          margin: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: SizedBox(
            width: widht,
            height: 300,
            child: Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Handphone'),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 50,
                    child: TextFormField(
                      controller: hp,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration.collapsed(
                          hintText: 'Nomor handphone anda',
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text('Password'),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 50,
                    child: TextFormField(
                      controller: password,
                      obscureText: true,
                      decoration: const InputDecoration.collapsed(
                          hintText: 'Password anda',
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  isLoading ? loadingButton() : loginButton(),
                  const SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/forget-password');
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.lock),
                              Text('Lupa password?'),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.person_sharp),
                              Text('Belum terdaftar?'),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      body: SingleChildScrollView(
        child: Column(
          children: [
            slider(),
            const SizedBox(
              height: 16,
            ),
            loginForm(),
            const VersionApp(),
          ],
        ),
      ),
    );
  }
}
