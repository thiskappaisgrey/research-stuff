{ lib, buildPythonPackage, fetchFromGitHub, setuptools, wheel, astroid, pep8
, pylint, pyparsing, pytest, pytest-cov, tox }:

buildPythonPackage rec {
  pname = "pyrtl";
  version = "unstable-2023-10-27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "UCSBarchlab";
    repo = "PyRTL";
    rev = "d5106addd0484c6e85e16514dd3322b371d1e12b";
    hash = "sha256-BMbsHVm96NMx7SLIxFEDkxLiDVFbqb+vu/3lI3bpdGc=";
  };

  nativeBuildInputs = [ setuptools wheel ];

  propagatedBuildInputs =
    [ astroid pep8 pylint pyparsing pytest pytest-cov tox ];

  pythonImportsCheck = [ "pyrtl" ];

  meta = with lib; {
    description =
      "A collection of classes providing simple hardware specification, simulation, tracing, and testing suitable for teaching and research.  Simplicity, usability, clarity, and extendability rather than performance or optimization is the overarching goal";
    homepage = "https://github.com/UCSBarchlab/PyRTL.git";
    changelog =
      "https://github.com/UCSBarchlab/PyRTL/blob/${src.rev}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
