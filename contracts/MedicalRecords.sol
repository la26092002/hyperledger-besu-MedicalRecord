// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract MedicalRecords {
    address public constant admin = 0xFE3B557E8Fb62b89F4916B721be55cEb828dBd73;

    mapping(address => string[]) public PersonalInfos;

    address[] public HospitalAccount;
    mapping(address => address[]) public DoctorAccount;
    address[] public DoctorsAddress;

    mapping(address => string[]) public Ehr; //address [patient];

    mapping(address => address[]) public AccesDoctor; //AccesDoctor[patient]=[doctor]
    mapping(address => address[]) public AccesHospital; //AccesDoctor[patient]=[hospital]
    struct EHR {
        address doctor;
        address hospitaAccount;
        uint256 id;
        string data;
    }

    function isDoctor() external view returns (bool) {
        bool access = false;
        for (uint256 i = 0; i < DoctorsAddress.length; i++) {
            if (DoctorsAddress[i] == msg.sender) {
                access = true;
            }
        }

        return access;
    }

    function isHospital() external view returns (bool) {
        bool access = false;
        for (uint256 i = 0; i < HospitalAccount.length; i++) {
            if (HospitalAccount[i] == msg.sender) {
                access = true;
            }
        }

        return access;
    }

    function isAdmin() external view returns (bool) {
        bool access = false;
        if (admin == msg.sender) {
            access = true;
        }
        return access;
    }

    function addHospitalAccount(address _user) external {
        require(admin == msg.sender, "You don't have access");
        uint256 j = HospitalAccount.length;
        bool exist = false;
        while (j > 0) {
            if (HospitalAccount[j - 1] == _user) {
                exist = true;
                break;
            } else {
                j--;
            }
        }
        require(!exist, "This Account is Added");
        HospitalAccount.push(_user);
    }

    //
    function displayHospitalAccountLength() external view returns (uint256) {
        return HospitalAccount.length;
    }

    function displayHospitalAccount(uint256 _id)
        external
        view
        returns (address)
    {
        require(_id < HospitalAccount.length, "Index out of bounds");
        return HospitalAccount[_id];
    }

    //

    function addDoctorAccount(address _user) external {
        bool ExistHospitalAccount = false;
        for (uint256 j = 0; j < HospitalAccount.length; j++) {
            if (HospitalAccount[j] == msg.sender) {
                ExistHospitalAccount = true;
                break;
            }
        }
        require(
            ExistHospitalAccount,
            "You dont have Access Because Hospital Account Dont Exist"
        );
        bool ExistDoctorAccount = false;
        for (uint256 j = 0; j < DoctorAccount[msg.sender].length; j++) {
            if (DoctorAccount[msg.sender][j] == _user) {
                ExistDoctorAccount = true;
                break;
            }
        }
        require(
            !ExistDoctorAccount,
            "You dont have Access to add Doctor Because exist"
        );
        DoctorAccount[msg.sender].push(_user);
        DoctorsAddress.push(_user);
    }

    function displayDoctorAccountLength() external view returns (uint256) {
        return DoctorAccount[msg.sender].length;
    }

    function displayDoctorAccount(uint256 _id) external view returns (address) {
        require(_id < DoctorAccount[msg.sender].length, "Index out of bounds");
        return DoctorAccount[msg.sender][_id];
    }

    //

    function createEhr(address _patient, string memory _data) external {
        //AccesDoctor[patient]=[doctor]
        bool acce = false;
        for (uint256 i = 0; i < AccesDoctor[_patient].length; i++) {
            if (AccesDoctor[_patient][i] == msg.sender) {
                acce = true;
            }
        }
        for (uint256 i = 0; i < AccesHospital[_patient].length; i++) {
            if (AccesHospital[_patient][i] == msg.sender) {
                acce = true;
            }
        }
        require(acce == true, "you dont have acces");

        for (uint256 j = 0; j < DoctorsAddress.length; j++) {
            // DoctorAccount
            if (DoctorsAddress[j] == msg.sender) {
                // Create a new EHR instance

                // Push the new EHR to the patient's EHR list
                Ehr[_patient].push(_data);
            }
        }
    }

    function concatenateStrings(string memory _a, string memory _b)
        public
        pure
        returns (string memory)
    {
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        string memory ab = new string(_ba.length + _bb.length);
        bytes memory bab = bytes(ab);
        uint256 k = 0;
        for (uint256 i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
        for (uint256 j = 0; j < _bb.length; j++) bab[k++] = _bb[j];
        return string(bab);
    }

    function ModifyEhr(
        address _patient,
        uint256 _id,
        string memory _data
    ) external {
        bool acce = false;
        for (uint256 i = 0; i < AccesDoctor[_patient].length; i++) {
            if (AccesDoctor[_patient][i] == msg.sender) {
                acce = true;
            }
        }
        for (uint256 i = 0; i < AccesHospital[_patient].length; i++) {
            if (AccesHospital[_patient][i] == msg.sender) {
                acce = true;
            }
        }
        require(acce == true, "you dont have acces");

        Ehr[_patient][_id] = _data;
    }

    function displayMedicalRecordsLength(address _patient)
        external
        view
        returns (uint256)
    {
        return Ehr[_patient].length;
    }

    function displayMedicalRecords(address _patient, uint256 _id)
        external
        view
        returns (string memory)
    {
        require(_id < Ehr[_patient].length, "Index out of bounds"); //???
        return Ehr[_patient][_id];
    }

    //AccesDoctor
    function accessDoctor(address _doctor) external {
        bool access = false;
        for (uint256 i = 0; i < AccesDoctor[msg.sender].length; i++) {
            if (AccesDoctor[msg.sender][i] == _doctor) {
                access = true;
            }
        }
        if (access == false) {
            AccesDoctor[msg.sender].push(_doctor);
        }
    }

    function displayaccessDoctorLength() external view returns (uint256) {
        return AccesDoctor[msg.sender].length;
    }

    function displayaccessDoctorLengthPatient(address _patient)
        external
        view
        returns (uint256)
    {
        return AccesDoctor[_patient].length;
    }

    function getAccesDoctorAtIndex(address _patient, uint256 _index)
        external
        view
        returns (address)
    {
        require(_index < AccesDoctor[_patient].length, "Index out of bounds");
        return AccesDoctor[_patient][_index];
    }

    function accessHospital(address _hospital) external {
        bool access = false;
        for (uint256 i = 0; i < AccesHospital[msg.sender].length; i++) {
            if (AccesDoctor[msg.sender][i] == _hospital) {
                access = true;
            }
        }
        if (access == false) {
            AccesHospital[msg.sender].push(_hospital);
        }
    }

    function displayaccessHospitalLength() external view returns (uint256) {
        return AccesHospital[msg.sender].length;
    }

    function getAccesHospitalAtIndex(address _patient, uint256 _index)
        external
        view
        returns (address)
    {
        require(_index < AccesHospital[_patient].length, "Index out of bounds");
        return AccesHospital[_patient][_index];
    }

    //Add personal infos
    function addPersonalInfos(string memory _data) external {
        PersonalInfos[msg.sender].push(_data);
    }

    function displayPersonalInfos() external view returns (string memory) {
        require(
            PersonalInfos[msg.sender].length > 0,
            "No personal information found"
        );
        return PersonalInfos[msg.sender][PersonalInfos[msg.sender].length - 1];
    }

    function displayPersonalInfosLength(address _user)
        external
        view
        returns (uint256)
    {
        return PersonalInfos[_user].length;
    }
}
