import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_pup_simple/puppy_profile/data/puppy_preferences.dart';
import 'package:my_pup_simple/puppy_profile/model/puppy.dart';
import 'package:my_pup_simple/src/constants/app_colors.dart';
import 'package:my_pup_simple/src/constants/app_sizes.dart';
import 'package:my_pup_simple/src/helpers/calculate_growth_stage.dart';
import 'package:my_pup_simple/src/helpers/calculate_time_between.dart';
import 'package:my_pup_simple/widgets/button.dart';
import 'package:my_pup_simple/widgets/profile.dart';
import 'package:my_pup_simple/widgets/text_field.dart';

class EditPuppyProfilePage extends StatefulWidget {
  const EditPuppyProfilePage({super.key});

  @override
  State<EditPuppyProfilePage> createState() => _EditPuppyProfilePageState();
}

class _EditPuppyProfilePageState extends State<EditPuppyProfilePage> {
  late Puppy puppy;
  late final TextEditingController _nameController;
  late final TextEditingController _birthdateController;
  late final TextEditingController _ownerController;

  @override
  void initState() {
    super.initState();

    puppy = PuppyPreferences.getMyPuppy();
    _nameController = TextEditingController(text: puppy.name);
    _birthdateController = TextEditingController(text: puppy.birthdate);
    _ownerController = TextEditingController(text: puppy.owner);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthdateController.dispose();
    _ownerController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30),
          alignment: Alignment.centerLeft,
          onPressed: () {
            // Navigate back to the previous screen by popping the current route
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p32),
        physics: const BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: puppy.imagePath,
            isEdit: true,
            onClicked: () async {
              final image =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              if (image == null) return;
              setState(() => puppy = puppy.copy(imagePath: image.path));
            },
          ),
          gapH24,
          Text(
            puppy.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          gapH24,
          TextFieldWidget(
            label: 'Name',
            text: puppy.name,
            controller: _nameController,
            onChanged: (name) => puppy = puppy.copy(name: name),
          ),
          gapH24,
          buildDateField(context, 'Birthdate', puppy.birthdate),
          gapH24,
          TextFieldWidget(
            label: 'Owner',
            text: puppy.owner,
            controller: _ownerController,
            onChanged: (owner) => puppy = puppy.copy(owner: owner),
          ),
          gapH24,
          ButtonWidget(
            text: 'SAVE',
            onClicked: () {
              PuppyPreferences.setMyPuppy(puppy);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget buildDateField(
    BuildContext context,
    String label,
    String text,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        gapH8,
        TextField(
          controller: _birthdateController,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.date_range,
              color: mainAppColor,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: mainAppColor),
            ),
          ),
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(
                DateTime.now().year - 35,
              ), // max age for dogs set to 35
              lastDate: DateTime(DateTime.now().year + 1),
            );

            if (pickedDate != null) {
              debugPrint(
                pickedDate.toString(),
              ); // pickedDate output format => 2021-03-10 00:00:00.000
              final formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
              debugPrint(
                formattedDate,
              ); // formatted date output using intl package => 2021-03-16

              final ageInWeeks = CalculateTimeBetween.weeksBetween(
                DateTime.parse(formattedDate),
                DateTime.now(),
              );
              final growthStage =
                  CalculateGrowthStage.getGrowthStage(ageInWeeks);

              setState(() {
                _birthdateController.text = formattedDate;

                puppy = puppy.copy(
                  birthdate: formattedDate,
                  ageInWeeks: ageInWeeks,
                  growthStage: growthStage,
                );
              });
            } else {
              debugPrint('Date is not selected');
            }
          },
          onChanged: (date) => {debugPrint('date changed')},
        ),
      ],
    );
  }
}
