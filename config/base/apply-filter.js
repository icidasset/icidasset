import sortBy from 'lodash/fp/sortBy';


export default function(fn, condition) {
  return (files, deps) => {
    return new Promise(resolve => {

      const yes = [];
      const no = [];

      files.forEach(file => {
        if (condition(file)) yes.push(file);
        else no.push(file);
      });

      Promise.resolve(fn(yes, deps)).then(processed => {
        resolve(sortBy('path', [...processed, ...no]));
      });

    });
  };
}
