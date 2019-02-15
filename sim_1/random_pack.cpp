using namespace std;

double random_uniform(void){
  random_device rd;
  mt19937 gen(rd());

  uniform_real_distribution<> dis(0.0, 1.0);

  return dis(gen);
}

double random_normal(void){
  random_device rd{};
  mt19937 gen{rd()};

  normal_distribution<> d{0,1};

  return d(gen);
}
